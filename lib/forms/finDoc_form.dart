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

import 'package:core/templates/@templates.dart';
import 'package:decimal/decimal.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:models/@models.dart';
import 'package:core/blocs/@blocs.dart';
import 'package:core/helper_functions.dart';
import '@forms.dart';

class FinDocForm extends StatelessWidget {
  final FormArguments formArguments;
  const FinDocForm({Key key, this.formArguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FinDoc finDoc = formArguments.object;

    MapItem finDocItem = MapItem(
        form: OrderPage(formArguments.message, finDoc),
        label:
            "${finDoc.salesString()} Sales ${finDoc.docType} #${finDoc.id()}",
        icon: Icon(Icons.home));

    if (finDoc.docType == 'invoice' || finDoc.docType == 'payment') {
      if (finDoc.sales) {
        acctSalesMap[finDoc.docType == 'invoice' ? 0 : 1] = finDocItem;
        BlocProvider.of<SalesCartBloc>(context)..add(LoadCart(finDoc));
        return MainTemplate(
          menu: acctMenuItems,
          mapItems: acctSalesMap,
          menuIndex: MENU_ACCTSALES,
          tabIndex: finDoc.docType == 'invoice' ? 0 : 1,
        );
      } else {
        acctPurchaseMap[finDoc.docType == 'invoice' ? 0 : 1] = finDocItem;
        BlocProvider.of<PurchCartBloc>(context)..add(LoadCart(finDoc));
        return MainTemplate(
          menu: acctMenuItems,
          mapItems: acctPurchaseMap,
          menuIndex: MENU_ACCTPURCHASE,
          tabIndex: finDoc.docType == 'invoice' ? 0 : 1,
        );
      }
    } // orders
    else if (finDoc.docType == 'order') {
      if (finDoc.sales) {
        salesMap[0] = finDocItem;
        BlocProvider.of<SalesCartBloc>(context)..add(LoadCart(finDoc));
        return MainTemplate(
          menu: menuItems,
          mapItems: salesMap,
          menuIndex: MENU_SALES,
          tabIndex: 0,
        );
      } else {
        purchaseMap[0] = finDocItem;
        BlocProvider.of<PurchCartBloc>(context)..add(LoadCart(finDoc));
        return MainTemplate(
          menu: menuItems,
          mapItems: purchaseMap,
          menuIndex: MENU_PURCHASE,
          tabIndex: 0,
        );
      }
    } else
      return Container();
  }
}

class OrderPage extends StatefulWidget {
  final String message;
  final FinDoc finDoc;
  OrderPage(this.message, this.finDoc);
  @override
  _MyFinDocState createState() => _MyFinDocState(message, finDoc);
}

class _MyFinDocState extends State<OrderPage> {
  final String message;
  final FinDoc finDocIn; // incoming existing finDoc from list
  final _formKeyHeader = GlobalKey<FormState>();
  final _formKeyItems = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _userSearchBoxController = TextEditingController();
  final _productSearchBoxController = TextEditingController();
  //ignore: close_sinks
  CartBloc _cartBloc;
  UserBloc _userBloc;
  FinDoc finDoc;
  List<ItemType> itemTypes;
  Product _selectedProduct;
  ItemType _selectedItemType;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  _MyFinDocState(this.message, this.finDocIn) {
    HelperFunctions.showTopMessage(scaffoldMessengerKey, message);
  }

  @override
  Widget build(BuildContext context) {
    bool isPhone = ResponsiveWrapper.of(context).isSmallerThan(TABLET);
    if (finDocIn.sales) {
      _cartBloc = BlocProvider.of<SalesCartBloc>(context);
      _userBloc = BlocProvider.of<CustomerBloc>(context);
    } else {
      _cartBloc = BlocProvider.of<PurchCartBloc>(context);
      _userBloc = BlocProvider.of<SupplierBloc>(context);
    }
    finDoc = finDocIn;
    var repos = context.read<Object>();
    if (finDocIn.sales)
      return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        if (state is AuthAuthenticated)
          itemTypes = state.authenticate.company.itemTypes.sales;
        return BlocListener<SalesFinDocBloc, FinDocState>(
            listener: (context, state) {
              if (state is FinDocProblem)
                HelperFunctions.showMessage(
                    context, '${state.errorMessage}', Colors.red);
              if (state is FinDocSuccess)
                HelperFunctions.showMessage(
                    context, '${state.message}', Colors.green);
            },
            child: BlocConsumer<SalesCartBloc, CartState>(
                listener: (context, state) {
              if (state is CartProblem) {
                HelperFunctions.showMessage(
                    context, '${state.errorMessage}', Colors.red);
              }
              if (state is CartLoaded) {
                HelperFunctions.showMessage(
                    context, '${state.message}', Colors.green);
              }
            }, builder: (context, state) {
              if (state is CartLoading)
                return Center(child: CircularProgressIndicator());
              if (state is CartLoaded) {
                finDoc = state.finDoc;
              }
              return Column(children: [
                SizedBox(height: 20),
                _headerEntry(repos),
                _itemEntry(repos, isPhone),
                _actionButtons(),
                Center(
                    child:
                        Text("Grant total : ${finDoc.grandTotal?.toString()}")),
                _finDocItemList(),
              ]);
            }));
      });
    // purchase finDoc
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated)
        itemTypes = state.authenticate.company.itemTypes.purchase;
      return BlocListener<PurchFinDocBloc, FinDocState>(
          listener: (context, state) {
            if (state is FinDocProblem)
              HelperFunctions.showMessage(
                  context, '${state.errorMessage}', Colors.red);
          },
          child: BlocConsumer<PurchCartBloc, CartState>(
              listener: (context, state) {
            if (state is CartProblem) {
              HelperFunctions.showMessage(
                  context, '${state.errorMessage}', Colors.red);
            }
            if (state is CartLoaded) {
              setState(() {
                HelperFunctions.showMessage(
                    context, '${state.message}', Colors.green);
              });
            }
          }, builder: (context, state) {
            if (state is CartLoading)
              return Center(child: CircularProgressIndicator());
            if (state is CartLoaded) {
              finDoc = state.finDoc;
            }
            return Column(children: [
              SizedBox(height: 20),
              _headerEntry(repos),
              _itemEntry(repos, isPhone),
              _actionButtons(),
              Center(
                  child:
                      Text("Grant total : ${finDoc.grandTotal?.toString()}")),
              _finDocItemList(),
            ]);
          }));
    });
  }

  Widget _headerEntry(repos) {
    int columns = ResponsiveWrapper.of(context).isSmallerThan(TABLET) ? 1 : 2;
    double width = columns.toDouble() * 350;
    return Center(
        child: Column(children: [
      Container(
          height: 150 / columns.toDouble(),
          width: width,
          child: Form(
              key: _formKeyHeader,
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: GridView.count(
                      crossAxisCount: columns,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: (6),
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
                              width: width / columns.toDouble() - 160,
                              child: DropdownSearch<User>(
                                label: finDoc.sales ? 'Customer' : 'Supplier',
                                dialogMaxWidth: 300,
                                autoFocusSearchBox: true,
                                selectedItem: finDoc.otherUser,
                                dropdownSearchDecoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                ),
                                searchBoxDecoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                ),
                                showSearchBox: true,
                                searchBoxController: _userSearchBoxController,
                                isFilteredOnline: true,
                                key: Key('dropUser'),
                                itemAsString: (User u) => "${u?.companyName}",
                                onFind: (String filter) async {
                                  var result = await repos.getUser(
                                      userGroupId: 'GROWERP_M_CUSTOMER',
                                      filter: _userSearchBoxController.text);
                                  return result;
                                },
                                onChanged: (User newValue) {
                                  setState(() {
                                    finDoc.otherUser = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null)
                                    return "Select ${finDoc.sales ? 'Customer' : 'Supplier'}!";
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              child: Text('Add New'),
                              onPressed: () async {
                                final User other = await _addOtherPartyDialog(
                                    context, finDoc.sales);
                                if (other != null) {
                                  _userBloc.add(UpdateUser(other));
                                }
                              },
                            )
                          ],
                        ),
                        TextFormField(
                          key: Key('description'),
                          decoration:
                              InputDecoration(labelText: 'FinDoc Description'),
                          controller: _descriptionController,
                        ),
                      ])))),
    ]));
  }

  Widget _itemEntry(repos, isPhone) {
    int columns = ResponsiveWrapper.of(context).isSmallerThan(TABLET) ? 1 : 2;
    double width = columns.toDouble() * 350;
    return Center(
        child: Column(children: [
      Container(
          height: 480 / columns.toDouble(),
          width: width,
          child: Form(
              key: _formKeyItems,
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: GridView.count(
                      crossAxisCount: columns,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: (5.5),
                      children: <Widget>[
                        DropdownButtonFormField<ItemType>(
                          hint: Text('Item type'),
                          value: _selectedItemType,
                          items: itemTypes?.map((item) {
                            return DropdownMenuItem<ItemType>(
                                child: Text(item.description), value: item);
                          })?.toList(),
                          validator: (value) {
                            if (value == null) return 'Select Item Type?';
                            return null;
                          },
                          onChanged: (ItemType newValue) {
                            setState(() {
                              _selectedItemType = newValue;
                            });
                          },
                          isExpanded: true,
                        ),
                        DropdownSearch<Product>(
                          label: 'Product',
                          dialogMaxWidth: 300,
                          autoFocusSearchBox: true,
                          selectedItem: _selectedProduct,
                          dropdownSearchDecoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                          ),
                          searchBoxDecoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                          ),
                          showSearchBox: true,
                          searchBoxController: _productSearchBoxController,
                          isFilteredOnline: true,
                          key: Key('dropDownLead'),
                          itemAsString: (Product u) => "${u.productName}",
                          onFind: (String filter) async {
                            var result = await repos.getProduct(
                                filter: _productSearchBoxController.text);
                            return result;
                          },
                          onChanged: (Product newValue) {
                            setState(() {
                              _selectedProduct = newValue;
                              _priceController.text = newValue.price.toString();
                              _itemDescriptionController.text =
                                  "${newValue.productName}[${newValue.productId}]";
                              _selectedItemType = itemTypes.firstWhere(
                                  (x) => x.itemTypeId == 'ItemProduct');
                            });
                          },
                        ),
                        TextFormField(
                          key: Key('itemDescription'),
                          decoration:
                              InputDecoration(labelText: 'Item Description'),
                          controller: _itemDescriptionController,
                          validator: (value) {
                            if (value.isEmpty) return 'Item description?';
                            return null;
                          },
                        ),
                        if (!isPhone) SizedBox(),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Price/Amount'),
                          controller: _priceController,
                          validator: (value) {
                            if (value.isEmpty) return 'Enter Price or Amount?';
                            return null;
                          },
                        ),
                        TextFormField(
                          key: Key('quantity'),
                          decoration: InputDecoration(labelText: 'Quantity'),
                          controller: _quantityController,
                        ),
                      ])))),
    ]));
  }

  Widget _actionButtons() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ElevatedButton(
              key: Key('cancel'),
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          ElevatedButton(
              key: Key('clear'),
              child: Text('Clear'),
              onPressed: () {
                if (finDoc.items.length > 0) {
                  _cartBloc.add(DeleteFromCart());
                }
              }),
          ElevatedButton(
              child: Text(finDoc.orderId == null &&
                      finDoc.invoiceId == null &&
                      finDoc.paymentId == null
                  ? 'Create '
                  : 'Update ' + '${finDoc.docType}'),
              onPressed: () {
                if (finDoc.items.length > 0) {
                  _cartBloc.add(CreateFinDocFromCart());
                }
              }),
          ElevatedButton(
              key: Key('addItem'),
              child: Text('Add Item'),
              onPressed: () {
                if (_formKeyHeader.currentState.validate() &&
                    _formKeyItems.currentState.validate()) {
                  _cartBloc.add(AddToCart(
                      finDoc: FinDoc(
                          docType: finDocIn.docType,
                          sales: finDocIn.sales,
                          otherUser: finDoc.otherUser,
                          description: _descriptionController.text,
                          items: finDoc.items),
                      newItem: FinDocItem(
                          itemTypeId: _selectedItemType.itemTypeId,
                          productId: _selectedProduct?.productId,
                          description: _itemDescriptionController.text,
                          price: Decimal.parse(_priceController.text),
                          quantity: Decimal.parse(
                              _quantityController.text.isEmpty
                                  ? "1"
                                  : _quantityController.text))));
                  setState(() {
                    _selectedProduct = null;
                    _priceController.clear();
                    _quantityController.clear();
                    _itemDescriptionController.clear();
                    _selectedItemType = null;
                  });
                }
              }),
        ]);
  }

  Widget _finDocItemList() {
    List<FinDocItem> items = finDoc?.items;

    return Expanded(
        child: CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
            child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
          ),
          title: Column(children: [
            Row(children: <Widget>[
              Expanded(child: Text("Item Type", textAlign: TextAlign.center)),
              Expanded(child: Text("Description", textAlign: TextAlign.center)),
              Expanded(child: Text("Quantity", textAlign: TextAlign.center)),
              Expanded(child: Text("Price", textAlign: TextAlign.center)),
              Expanded(child: Text("SubTotal", textAlign: TextAlign.center)),
            ]),
            Divider(color: Colors.black),
          ]),
        )),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return InkWell(
                  onLongPress: () async {
                    _cartBloc.add(DeleteFromCart(index));
                    Navigator.pushNamed(context, '/finDoc',
                        arguments: FormArguments(
                            message: 'item deleted',
                            menuIndex: 0,
                            object: finDoc));
                  },
                  child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Text(items[index]?.itemSeqId.toString()),
                      ),
                      title: Row(children: <Widget>[
                        Expanded(
                            child: Text(
                                itemTypes
                                    .firstWhere((x) =>
                                        x.itemTypeId == items[index].itemTypeId)
                                    .description,
                                textAlign: TextAlign.center)),
                        Expanded(
                            child: Text("${items[index].description}",
                                textAlign: TextAlign.center)),
                        Expanded(
                            child: Text("${items[index].quantity}",
                                textAlign: TextAlign.center)),
                        Expanded(
                            child: Text("${items[index].price}",
                                textAlign: TextAlign.center)),
                        Expanded(
                            child: Text(
                                "${(items[index].price * items[index].quantity).toString()}",
                                textAlign: TextAlign.center)),
                      ]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_forever),
                        onPressed: () {
                          _cartBloc.add(DeleteFromCart(index));
                        },
                      )));
            },
            childCount: items == null ? 0 : items?.length,
          ),
        ),
      ],
    ));
  }
}

_addOtherPartyDialog(BuildContext context, bool sales) async {
  final _formKeyDialog = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  User updatedUser;

  return showDialog<User>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Text('Enter a new Customer', textAlign: TextAlign.center),
        content: Container(
            height: 300,
            width: 200,
            child: Form(
                key: _formKeyDialog,
                child: ListView(children: <Widget>[
                  SizedBox(height: 10),
                  TextFormField(
                    key: Key('firstName'),
                    decoration: InputDecoration(labelText: 'First Name'),
                    controller: _firstNameController,
                    validator: (value) {
                      if (value.isEmpty) return 'enter a first name?';
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    key: Key('lastName'),
                    decoration: InputDecoration(labelText: 'Last Name'),
                    controller: _lastNameController,
                    validator: (value) {
                      if (value.isEmpty) return 'enter a last name?';
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email address'),
                    controller: _emailController,
                    validator: (String value) {
                      if (value.isEmpty) return 'enter an Email address?';
                      if (!RegExp(
                              r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                          .hasMatch(value)) {
                        return 'This is not a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                      child: Text('Create'),
                      onPressed: () {
                        if (_formKeyDialog.currentState.validate()) {
                          //} && !loading) {
                          updatedUser = User(
                            userGroupId: sales
                                ? 'GROWERP_M_CUSTOMER'
                                : 'GROWERP_M_SUPPLIER',
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            email: _emailController.text,
                            name: _emailController.text,
                          );
                          Navigator.of(context).pop();
                        }
                      })
                ]))),
      );
    },
  );
}
