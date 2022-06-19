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

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:core/domains/common/functions/helper_functions.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:core/domains/domains.dart';
import 'package:core/templates/@templates.dart';
import '../../../api_repository.dart';

class ProductDialog extends StatelessWidget {
  final Product product;
  const ProductDialog(this.product);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          CategoryBloc(context.read<APIRepository>())..add(CategoryFetch()),
      child: ProductDialogFull(product),
    );
  }
}

class ProductDialogFull extends StatefulWidget {
  final Product product;
  const ProductDialogFull(this.product);
  @override
  _ProductState createState() => _ProductState(product);
}

class _ProductState extends State<ProductDialogFull> {
  final Product product;
  _ProductState(this.product);

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _listPriceController = TextEditingController();
  TextEditingController _assetsController = TextEditingController();

  late bool useWarehouse;
  String? _selectedTypeId;
  XFile? _imageFile;
  dynamic _pickImageError;
  String? _retrieveDataError;
  late String classificationId;
  final ImagePicker _picker = ImagePicker();
  late List<Category> _selectedCategories;

  @override
  void initState() {
    super.initState();
    _nameController.text = product.productName ?? '';
    _descriptionController.text = product.description ?? '';
    _priceController.text =
        product.price == null ? '' : product.price.toString();
    _listPriceController.text =
        product.assetCount == null ? '' : product.listPrice.toString();
    _assetsController.text =
        product.listPrice == null ? '' : product.assetCount.toString();
    _selectedCategories = List.of(product.categories);
    _selectedTypeId = product.productTypeId ?? null;
    classificationId = GlobalConfiguration().get("classificationId");
    useWarehouse = product.useWarehouse;
  }

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
    final LostDataResponse response = await _picker.retrieveLostData();
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
    bool isPhone = ResponsiveWrapper.of(context).isSmallerThan(TABLET);
    if (classificationId == 'AppHotel') _selectedTypeId = 'Rental';
    return BlocListener<ProductBloc, ProductState>(
        listener: (context, state) async {
          switch (state.status) {
            case ProductStatus.success:
              Navigator.of(context).pop();
              break;
            case ProductStatus.failure:
              HelperFunctions.showMessage(
                  context, 'Error: ${state.message}', Colors.red);
              break;
            default:
              Text("????");
          }
        },
        child: BlocConsumer<CategoryBloc, CategoryState>(
            listener: (context, state) async {
          switch (state.status) {
            case CategoryStatus.failure:
              HelperFunctions.showMessage(context,
                  'Error getting categories: ${state.message}', Colors.red);
              break;
            default:
          }
        }, builder: (context, state) {
          if (state.status == CategoryStatus.success)
            return Scaffold(
                backgroundColor: Colors.transparent,
                floatingActionButton:
                    imageButtons(context, _onImageButtonPressed),
                body: Dialog(
                    key: Key('ProductDialog'),
                    insetPadding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(clipBehavior: Clip.none, children: [
                      listChild(classificationId, isPhone, state),
                      Positioned(top: 5, right: 5, child: DialogCloseButton()),
                    ])));
          return LoadingIndicator();
        }));
  }

  Widget listChild(String classificationId, bool isPhone, state) {
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
                return _showForm(classificationId, isPhone, state);
              })
          : _showForm(classificationId, isPhone, state);
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

  Widget _showForm(String classificationId, bool isPhone, CategoryState state) {
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
    return Center(
        child: Container(
            width: 400,
            padding: EdgeInsets.all(20),
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    key: Key('listView'),
                    child: Column(children: <Widget>[
                      Center(
                          child: Text(
                        'Product #${product.productId.isEmpty ? " New" : product.productId}',
                        style: TextStyle(
                            fontSize: isPhone ? 10 : 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        key: Key('header'),
                      )),
                      SizedBox(height: 20),
                      CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 80,
                          child: _imageFile != null
                              ? foundation.kIsWeb
                                  ? Image.network(_imageFile!.path)
                                  : Image.file(File(_imageFile!.path))
                              : product.image != null
                                  ? Image.memory(
                                      product.image!,
                                    )
                                  : Text(
                                      product.productName?.substring(0, 1) ??
                                          '',
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.black))),
                      SizedBox(height: 30),
                      TextFormField(
                        key: Key('name'),
                        decoration: InputDecoration(
                            labelText: classificationId == 'AppHotel'
                                ? 'Room Type Name'
                                : 'Product Name'),
                        controller: _nameController,
                        validator: (value) {
                          return value!.isEmpty ? 'Please enter a name?' : null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        key: Key('description'),
                        maxLines: 3,
                        decoration: InputDecoration(labelText: 'Description'),
                        controller: _descriptionController,
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Please enter a description?'
                              : null;
                        },
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              key: Key('listPrice'),
                              decoration:
                                  InputDecoration(labelText: 'List Price'),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp('[0-9.,]+'))
                              ],
                              controller: _listPriceController,
                              validator: (value) {
                                return value!.isEmpty
                                    ? 'Please enter a list price?'
                                    : null;
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              key: Key('price'),
                              decoration:
                                  InputDecoration(labelText: 'Current Price'),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp('[0-9.,]+'))
                              ],
                              controller: _priceController,
                            ),
                          )
                        ],
                      ),
                      Visibility(
                          visible: classificationId != 'AppHotel',
                          child: Column(children: [
                            SizedBox(height: 10),
                            Container(
                              width: 400,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                border: Border.all(
                                    color: Colors.black45,
                                    style: BorderStyle.solid,
                                    width: 0.80),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ElevatedButton(
                                    key: Key('addCategories'),
                                    onPressed: () async {
                                      var result = await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return MultiSelect<Category>(
                                              title:
                                                  'Select one or more categories',
                                              items: state.categories,
                                              selectedItems:
                                                  _selectedCategories,
                                            );
                                          });
                                      if (result != null) {
                                        setState(() {
                                          _selectedCategories = result;
                                        });
                                      }
                                    },
                                    child: const Text('Assign to category'),
                                  ),

                                  // display selected items
                                  Wrap(
                                    spacing: 10.0,
                                    children: _selectedCategories
                                        .map((Category e) => Chip(
                                              label: Text(
                                                e.categoryName,
                                                key: Key(e.categoryName),
                                              ),
                                              deleteIcon: const Icon(
                                                Icons.cancel,
                                                key: Key("deleteChip"),
                                              ),
                                              onDeleted: () async {
                                                setState(() {
                                                  _selectedCategories.remove(e);
                                                });
                                              },
                                            ))
                                        .toList(),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              key: Key('productTypeDropDown'),
                              value: _selectedTypeId,
                              decoration:
                                  InputDecoration(labelText: 'Product Type'),
                              validator: (value) {
                                return value == null ? 'field required' : null;
                              },
                              items: productTypes.map((item) {
                                return DropdownMenuItem<String>(
                                    child: Text(item,
                                        style: TextStyle(
                                            color: Color(0xFF4baa9b))),
                                    value: item);
                              }).toList(),
                              onChanged: (String? newValue) {
                                _selectedTypeId = newValue!;
                              },
                              isExpanded: true,
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        border: Border.all(
                                            color: Colors.black45,
                                            style: BorderStyle.solid,
                                            width: 0.80),
                                      ),
                                      child: CheckboxListTile(
                                          key: Key('useWarehouse'),
                                          title: Text("Use Warehouse?",
                                              style: TextStyle(
                                                  color: Color(0xFF4baa9b))),
                                          value: useWarehouse,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              useWarehouse = value!;
                                            });
                                          })),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    key: Key('assets'),
                                    decoration: InputDecoration(
                                        labelText: 'Assets in warehouse'),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp('[0-9.,]+'))
                                    ],
                                    controller: _assetsController,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                                key: Key('update'),
                                child: Text(product.productId.isEmpty
                                    ? 'Create'
                                    : 'Update'),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    Uint8List? image =
                                        await HelperFunctions.getResizedImage(
                                            _imageFile?.path);
                                    if (_imageFile?.path != null &&
                                        image == null)
                                      HelperFunctions.showMessage(
                                          context,
                                          "Image upload error or larger than 200K",
                                          Colors.red);
                                    else
                                      context.read<ProductBloc>().add(
                                          ProductUpdate(Product(
                                              productId: product.productId,
                                              productName: _nameController.text,
                                              assetClassId:
                                                  classificationId ==
                                                          'AppHotel'
                                                      ? 'Hotel Room'
                                                      : null,
                                              description:
                                                  _descriptionController.text,
                                              listPrice: Decimal.parse(
                                                  _listPriceController.text),
                                              price: Decimal.parse(
                                                  _priceController.text.isEmpty
                                                      ? '0.00'
                                                      : _priceController.text),
                                              assetCount: _assetsController
                                                      .text.isEmpty
                                                  ? 0
                                                  : int.parse(
                                                      _assetsController.text),
                                              categories: _selectedCategories,
                                              productTypeId: _selectedTypeId,
                                              useWarehouse: useWarehouse,
                                              image: image)));
                                  }
                                })
                          ])),
                    ])))));
  }
}
