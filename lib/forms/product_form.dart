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
import '../models/@models.dart';
import '../blocs/@blocs.dart';
import '../helper_functions.dart';
import '../routing_constants.dart';
import '../widgets/@widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ProductForm extends StatelessWidget {
  final FormArguments formArguments;
  ProductForm(this.formArguments);

  @override
  Widget build(BuildContext context) {
    var a = (formArguments) =>
        (MyProductPage(formArguments.message, formArguments.object));
    return CheckConnectAndAddRail(a(formArguments), 3);
  }
}

class MyProductPage extends StatefulWidget {
  final String message;
  final Product category;
  MyProductPage(this.message, this.category);
  @override
  _MyProductState createState() => _MyProductState(message, category);
}

class _MyProductState extends State<MyProductPage> {
  final String message;
  final Product product;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  Catalog catalog;
  Product updatedProduct;
  bool loading = false;
  ProductCategory _selectedCategory;
  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _MyProductState(this.message, this.product) {
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
              title: companyLogo(context, authenticate, 'Product detail'),
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
                    HelperFunctions.showMessage(
                        context, '${state.errorMessage}', Colors.green);
                  }
                  if (state is CatalogLoaded)
                    Navigator.pushNamed(context, CategoriesRoute,
                        arguments: FormArguments(state.message, state.catalog));
                }, builder: (context, state) {
                  if (state is CatalogLoaded) {
                    catalog = state.catalog;
                    updatedProduct = state.product;
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
                                return _showForm(updatedProduct);
                              })
                          : _showForm(updatedProduct),
                    );
                  }
                  return Container(child: Text("needs logging in"));
                })));
      }
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

  Widget _showForm(updatedProduct) {
    _nameController..text = product?.name;
    _descriptionController..text = product?.description;
    _priceController
      ..text = product?.price != null ? product.price.toString() : '';
    final Text retrieveError = _getRetrieveErrorWidget();
    if (_selectedCategory == null && product?.productCategoryId != null)
      _selectedCategory = catalog.categories
          .firstWhere((a) => a.categoryId == product?.productCategoryId);
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
          Navigator.pop(context, updatedProduct);
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
                          BlocProvider.of<AuthBloc>(context).add(
                              UploadImage(product.productId, pickedFile.path));
                        },
                        child: CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 80,
                            child: _imageFile != null
                                ? kIsWeb
                                    ? Image.network(_imageFile.path)
                                    : Image.file(File(_imageFile.path))
                                : product?.image != null
                                    ? Image.memory(product?.image)
                                    : Text(product?.name?.substring(0, 1) ?? '',
                                        style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.black))),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        key: Key('name'),
                        decoration: InputDecoration(labelText: 'Product Name'),
                        controller: _nameController,
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please enter a product name?';
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        key: Key('description'),
                        decoration: InputDecoration(labelText: 'Description'),
                        controller: _descriptionController,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        key: Key('price'),
                        decoration: InputDecoration(labelText: 'Product Price'),
                        controller: _priceController,
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter a price?';
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 400,
                        height: 60,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                              color: Colors.grey,
                              style: BorderStyle.solid,
                              width: 0.80),
                        ),
                        child: DropdownButton<ProductCategory>(
                          key: Key('dropDown'),
                          underline: SizedBox(), // remove underline
                          hint: Text('Product Category'),
                          value: _selectedCategory,
                          items: catalog?.categories?.map((item) {
                            return DropdownMenuItem<ProductCategory>(
                                child: Text(item.categoryName), value: item);
                          })?.toList(),
                          onChanged: (ProductCategory newValue) {
                            setState(() {
                              _selectedCategory = newValue;
                            });
                          },
                          isExpanded: true,
                        ),
                      ),
                      SizedBox(height: 20),
                      RaisedButton(
                          key: Key('update'),
                          child: Text(
                              product?.productId == null ? 'Create' : 'Update'),
                          onPressed: () {
                            if (_formKey.currentState.validate())
                              //&& state is! ProductsLoading)
                              updatedProduct = Product(
                                productId: product?.productId,
                                name: _nameController.text,
                                description: _descriptionController.text,
                                price: double.parse(_priceController.text),
                                productCategoryId: _selectedCategory.categoryId,
                              );
                            BlocProvider.of<CatalogBloc>(context)
                                .add(UpdateProduct(
                              catalog,
                              updatedProduct,
                              _imageFile?.path,
                            ));
                          })
                    ])))));
  }
}