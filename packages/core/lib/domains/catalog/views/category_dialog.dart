/*
 * This GrowERP software is in the public domain under CC0 1.0 Universal plus a
 * Grant of Patent License.
 * 
 * To the extent possible under law, the author(s) have dedicated all
 * copyright and related and neighboring rights to this software to the
 * public domain worldwide. This software is distributed without any
 * warranty.
 * 
 * You should have received a copy of the CC0 Public Domain Dedication
 * along with this software (see the LICENSE.md file). If not, see
 * <http://creativecommons.org/publicdomain/zero/1.0/>.
 */

import 'dart:io';
import 'package:core/domains/common/functions/helper_functions.dart';
import 'package:core/templates/@templates.dart';
import 'package:core/widgets/dialogCloseButton.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:core/domains/domains.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CategoryDialog extends StatefulWidget {
  final Category category;
  CategoryDialog(this.category);
  @override
  _CategoryState createState() => _CategoryState(category);
}

class _CategoryState extends State<CategoryDialog> {
  final Category category;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descrController = TextEditingController();

  bool loading = false;
  late Category updatedCategory;
  XFile? _imageFile;
  dynamic _pickImageError;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  _CategoryState(this.category);

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Future<void> retrieveLostData() async {
    final response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) async {
          switch (state.status) {
            case CategoryStatus.success:
              HelperFunctions.showMessage(
                  context, 'Error: ${state.message}', Colors.green);
              Navigator.of(context).pop();
              break;
            case CategoryStatus.failure:
              HelperFunctions.showMessage(
                  context, 'Error: ${state.message}', Colors.red);
              break;
            default:
              Text("????");
          }
        },
        child: Dialog(
            key: Key('CategoryDialog'),
            insetPadding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ScaffoldMessenger(
                key: scaffoldMessengerKey,
                child: Scaffold(
                    backgroundColor: Colors.transparent,
                    floatingActionButton:
                        imageButtons(context, _onImageButtonPressed),
                    body: Stack(clipBehavior: Clip.none, children: [
                      listChild(),
                      Positioned(
                          top: -10, right: -10, child: DialogCloseButton()),
                    ])))));
  }

  Widget listChild() {
    return Builder(builder: (BuildContext context) {
      return !foundation.kIsWeb &&
              foundation.defaultTargetPlatform == TargetPlatform.android
          ? FutureBuilder<void>(
              future: retrieveLostData(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    'Pick image error: ${snapshot.error}}',
                    textAlign: TextAlign.center,
                  );
                }
                return _showForm();
              })
          : _showForm();
    });
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _showForm() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    }
    return _categoryDialog();
  }

  Widget _categoryDialog() {
    _nameController..text = category.categoryName ?? '';
    _descrController..text = category.description ?? '';
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    }
    bool isPhone = ResponsiveWrapper.of(context).isSmallerThan(TABLET);
    return Center(
        child: Container(
            width: 400,
            padding: EdgeInsets.all(20),
            child: Form(
                key: _formKey,
                child: ListView(key: Key('listView'), children: <Widget>[
                  Center(
                      child: Text(
                    'Category #${category.categoryId.isEmpty ? " New" : category.categoryId}',
                    style: TextStyle(
                        fontSize: isPhone ? 10 : 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    key: Key('header'),
                  )),
                  SizedBox(height: 30),
                  CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 80,
                      child: _imageFile != null
                          ? foundation.kIsWeb
                              ? Image.network(_imageFile!.path)
                              : Image.file(File(_imageFile!.path))
                          : category.image != null
                              ? Image.memory(category.image!)
                              : Text(
                                  category.categoryName?.substring(0, 1) ?? '',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.black))),
                  SizedBox(height: 30),
                  TextFormField(
                    key: Key('name'),
                    decoration: InputDecoration(labelText: 'Category Name'),
                    controller: _nameController,
                    validator: (value) {
                      return value!.isEmpty
                          ? 'Please enter a category name?'
                          : null;
                    },
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    key: Key('description'),
                    decoration: InputDecoration(labelText: 'Description'),
                    controller: _descrController,
                    maxLines: 3,
                    validator: (value) {
                      if (value!.isEmpty)
                        return 'Please enter a category description?';
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                      key: Key('update'),
                      child: Text(
                          category.categoryId.isEmpty ? 'Create' : 'Update'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          updatedCategory = Category(
                              categoryId: category.categoryId,
                              categoryName: _nameController.text,
                              description: _descrController.text,
                              image: await HelperFunctions.getResizedImage(
                                  _imageFile?.path));
                          if (_imageFile?.path != null &&
                              updatedCategory.image == null)
                            HelperFunctions.showMessage(
                                context,
                                "Image upload error or larger than 200K",
                                Colors.red);
                          else
                            BlocProvider.of<CategoryBloc>(context)
                                .add(CategoryUpdate(
                              updatedCategory,
                            ));
                        }
                      }),
                ]))));
  }
}
