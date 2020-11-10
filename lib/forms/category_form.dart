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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../models/@models.dart';
import '../blocs/@blocs.dart';
import '../helper_functions.dart';
import '../routing_constants.dart';
import '../widgets/@widgets.dart';

class CategoryForm extends StatelessWidget {
  final FormArguments formArguments;
  CategoryForm(this.formArguments);

  @override
  Widget build(BuildContext context) {
    var a = (formArguments) =>
        (MyCategoryPage(formArguments.message, formArguments.object));
    return CheckConnectAndAddRail(a(formArguments), 4);
  }
}

class MyCategoryPage extends StatefulWidget {
  final String message;
  final ProductCategory category;
  MyCategoryPage(this.message, this.category);
  @override
  _MyCategoryState createState() => _MyCategoryState(message, category);
}

class _MyCategoryState extends State<MyCategoryPage> {
  final String message;
  final ProductCategory category;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  ProductCategory updatedCategory;
  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _MyCategoryState(this.message, this.category) {
    HelperFunctions.showTopMessage(_scaffoldKey, message);
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(
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
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) {
        Authenticate authenticate = state.authenticate;
        return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading:
                  ResponsiveWrapper.of(context).isSmallerThan(TABLET),
              title: companyLogo(context, authenticate, 'Category detail'),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.home),
                    onPressed: () => Navigator.pushNamed(context, HomeRoute,
                        arguments: FormArguments()))
              ],
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 100),
                FloatingActionButton(
                  onPressed: () {
                    _onImageButtonPressed(ImageSource.gallery,
                        context: context);
                  },
                  heroTag: 'image0',
                  tooltip: 'Pick Image from gallery',
                  child: const Icon(Icons.photo_library),
                ),
                SizedBox(height: 20),
                FloatingActionButton(
                  onPressed: () {
                    _onImageButtonPressed(ImageSource.camera, context: context);
                  },
                  heroTag: 'image1',
                  tooltip: 'Take a Photo',
                  child: const Icon(Icons.camera_alt),
                ),
              ],
            ),
            drawer: myDrawer(context, authenticate),
            body: BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthProblem)
                    HelperFunctions.showMessage(
                        context, '${state.errorMessage}', Colors.red);
                },
                child: BlocConsumer<CatalogBloc, CatalogState>(
                    listener: (context, state) {
                  if (state is CatalogProblem) {
                    updatedCategory = state.newCategory;
                    HelperFunctions.showMessage(
                        context, '${state.errorMessage}', Colors.green);
                  }
                  if (state is CatalogLoaded)
                    Navigator.pushNamed(context, CategoriesRoute,
                        arguments: FormArguments(state.message, state.catalog));
                }, builder: (context, state) {
                  if (state is CatalogLoading)
                    HelperFunctions.showMessage(
                        context, 'processing...', Colors.green);
                  if (state is CatalogLoaded) updatedCategory = state.category;
                  return Center(
                    child: !kIsWeb &&
                            defaultTargetPlatform == TargetPlatform.android
                        ? FutureBuilder<void>(
                            future: retrieveLostData(),
                            builder: (BuildContext context,
                                AsyncSnapshot<void> snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                  'Pick image error: ${snapshot.error}}',
                                  textAlign: TextAlign.center,
                                );
                              }
                              return _showForm(updatedCategory);
                            })
                        : _showForm(updatedCategory),
                  );
                })));
      }
      return Container(child: Text("needs logging in"));
    });
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _showForm(updatedCategory) {
    _nameController..text = category?.categoryName;
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    }
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, updatedCategory);
          return false;
        },
        child: Center(
            child: Container(
                width: 400,
                child: Form(
                    key: _formKey,
                    child: ListView(children: <Widget>[
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: () async {
                          PickedFile pickedFile = await _picker.getImage(
                              source: ImageSource.gallery);
                          BlocProvider.of<AuthBloc>(context).add(UploadImage(
                              category.categoryId, pickedFile.path));
                        },
                        child: CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 80,
                            child: _imageFile != null
                                ? kIsWeb
                                    ? Image.network(_imageFile.path)
                                    : Image.file(File(_imageFile.path))
                                : category?.image != null
                                    ? Image.memory(category?.image)
                                    : Text(
                                        category?.categoryName
                                                ?.substring(0, 1) ??
                                            '',
                                        style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.black))),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        key: Key('name'),
                        decoration: InputDecoration(labelText: 'Category Name'),
                        controller: _nameController,
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please enter a category name?';
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      RaisedButton(
                          key: Key('update'),
                          child: Text(category?.categoryId == null
                              ? 'Create'
                              : 'Update'),
                          onPressed: () {
                            if (_formKey.currentState.validate())
                              //&& state is! CategorysLoading)
                              updatedCategory = ProductCategory(
                                categoryId: category?.categoryId,
                                categoryName: _nameController.text,
                              );
                            BlocProvider.of<CatalogBloc>(context)
                                .add(UpdateCategory(
                              null, //catalog,
                              updatedCategory,
                              _imageFile?.path,
                            ));
                          })
                    ])))));
  }
}
