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
import 'package:decimal/decimal.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:models/@models.dart';
import 'package:core/blocs/@blocs.dart';
import 'package:core/helper_functions.dart';
import 'package:core/widgets/@widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ProductForm extends StatelessWidget {
  final FormArguments formArguments;
  ProductForm(this.formArguments);

  @override
  Widget build(BuildContext context) {
    var a = (formArguments) =>
        (ProductPage(formArguments.message, formArguments.object));
    return ShowNavigationRail(a(formArguments), 3);
  }
}

class ProductPage extends StatefulWidget {
  final String message;
  final Product product;
  ProductPage(this.message, this.product);
  @override
  _ProductState createState() => _ProductState(message, product);
}

class _ProductState extends State<ProductPage> {
  final String message;
  final Product product;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categorySearchBoxController = TextEditingController();

  bool loading = false;
  Product updatedProduct;
  ProductCategory _selectedCategory;
  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  _ProductState(this.message, this.product) {
    HelperFunctions.showTopMessage(scaffoldMessengerKey, message);
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
    var repos = context.read<Object>();
    Authenticate authenticate;
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) authenticate = state.authenticate;
      return ScaffoldMessenger(
          key: scaffoldMessengerKey,
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading:
                    ResponsiveWrapper.of(context).isSmallerThan(TABLET),
                title: companyLogo(context, authenticate,
                    'Product detail #${product.productId}'),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.home),
                      onPressed: () => Navigator.pushNamed(context, 'home',
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
                  Visibility(
                    visible: !kIsWeb,
                    child: FloatingActionButton(
                      onPressed: () {
                        _onImageButtonPressed(ImageSource.camera,
                            context: context);
                      },
                      heroTag: 'image1',
                      tooltip: 'Take a Photo',
                      child: const Icon(Icons.camera_alt),
                    ),
                  )
                ],
              ),
              drawer: myDrawer(context, authenticate),
              body: BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthProblem)
                      HelperFunctions.showMessage(
                          context, '${state.errorMessage}', Colors.red);
                  },
                  child: BlocListener<ProductBloc, ProductState>(
                      listener: (context, state) {
                    if (state is ProductProblem) {
                      loading = false;
                      HelperFunctions.showMessage(
                          context, '${state.errorMessage}', Colors.red);
                    }
                    if (state is ProductSuccess) Navigator.of(context).pop();
                  }, child: Builder(builder: (BuildContext context) {
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
                                return _showForm(
                                    repos, authenticate.company.partyId);
                              })
                          : _showForm(repos, authenticate.company.partyId),
                    );
                  })))));
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

  Widget _showForm(repos, companyPartyId) {
    _nameController..text = product?.productName;
    _descriptionController..text = product?.description;
    _priceController..text = product?.price?.toString();
    final Text retrieveError = _getRetrieveErrorWidget();
    if (_selectedCategory == null && product?.categoryId != null)
      _selectedCategory = ProductCategory(
          categoryId: product.categoryId, categoryName: product.categoryName);
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
            child: Form(
                key: _formKey,
                child: ListView(children: <Widget>[
                  SizedBox(height: 30),
                  CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 80,
                      child: _imageFile != null
                          ? kIsWeb
                              ? Image.network(_imageFile.path)
                              : Image.file(File(_imageFile.path))
                          : product?.image != null
                              ? Image.memory(
                                  product?.image,
                                )
                              : Text(
                                  product?.productName?.substring(0, 1) ?? '',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.black))),
                  SizedBox(height: 30),
                  TextFormField(
                    key: Key('name'),
                    decoration: InputDecoration(labelText: 'Product Name'),
                    controller: _nameController,
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter a product name?';
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    key: Key('description'),
                    maxLines: 5,
                    decoration: InputDecoration(labelText: 'Description'),
                    controller: _descriptionController,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    key: Key('price'),
                    decoration: InputDecoration(labelText: 'Product Price'),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp('[0-9.,]+'))
                    ],
                    controller: _priceController,
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter a price?';
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownSearch<ProductCategory>(
                    label: 'Category',
                    dialogMaxWidth: 300,
                    autoFocusSearchBox: true,
                    selectedItem: _selectedCategory,
                    dropdownSearchDecoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                    ),
                    searchBoxDecoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                    ),
                    showSearchBox: true,
                    searchBoxController: _categorySearchBoxController,
                    isFilteredOnline: true,
                    showClearButton: true,
                    key: Key('dropDownCategory'),
                    itemAsString: (ProductCategory u) => "${u.categoryName}",
                    onFind: (String filter) async {
                      var result = await repos.getCategory(
                          companyPartyId: companyPartyId,
                          filter: _categorySearchBoxController.text);
                      return result;
                    },
                    onChanged: (ProductCategory newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                      key: Key('update'),
                      child: Text(
                          product?.productId == null ? 'Create' : 'Update'),
                      onPressed: () async {
                        if (_formKey.currentState.validate() && !loading) {
                          updatedProduct = Product(
                              productId: product?.productId,
                              productName: _nameController.text,
                              description: _descriptionController.text,
                              price: Decimal.parse(_priceController.text),
                              categoryId: _selectedCategory.categoryId,
                              image: await HelperFunctions.getResizedImage(
                                  _imageFile?.path));
                          BlocProvider.of<ProductBloc>(context)
                              .add(UpdateProduct(
                            updatedProduct,
                          ));
                        }
                      }),
                  SizedBox(height: 20),
                  RaisedButton(
                      key: Key('cancel'),
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ]))));
  }
}
