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

import 'package:decimal/decimal.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:models/@models.dart';
import 'package:core/blocs/@blocs.dart';
import 'package:core/helper_functions.dart';
import 'package:core/widgets/@widgets.dart';

class OrderForm extends StatelessWidget {
  final FormArguments formArguments;
  OrderForm(this.formArguments);

  @override
  Widget build(BuildContext context) {
    var a = (formArguments) =>
        (MyOrderPage(formArguments.message, formArguments.object));
    Order order = formArguments.object;
    print("=====orderform input order: $order");
    if (order.sales)
      BlocProvider.of<SalesCartBloc>(context)..add(LoadCart(order));
    else
      BlocProvider.of<PurchCartBloc>(context)..add(LoadCart(order));

    return ShowNavigationRail(a(formArguments), formArguments.tab);
  }
}

class MyOrderPage extends StatefulWidget {
  final String message;
  final Order order;
  MyOrderPage(this.message, this.order);
  @override
  _MyOrderState createState() => _MyOrderState(message, order);
}

class _MyOrderState extends State<MyOrderPage> {
  final String message;
  final Order orderIn; // incoming existing order from list
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _userSearchBoxController = TextEditingController();
  final _productSearchBoxController = TextEditingController();
  //ignore: close_sinks
  CartBloc _cartBloc;
  UserBloc _userBloc;
  Order order;
  Authenticate authenticate;
  Product _selectedProduct;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  _MyOrderState(this.message, this.orderIn) {
    HelperFunctions.showTopMessage(scaffoldMessengerKey, message);
  }

  @override
  Widget build(BuildContext context) {
    if (orderIn.sales) {
      _cartBloc = BlocProvider.of<SalesCartBloc>(context);
      _userBloc = BlocProvider.of<CustomerBloc>(context);
    } else {
      _cartBloc = BlocProvider.of<PurchCartBloc>(context);
      _userBloc = BlocProvider.of<SupplierBloc>(context);
    }
    order = orderIn;
    var repos = context.read<Object>();
    if (orderIn.sales)
      return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        if (state is AuthAuthenticated) authenticate = state.authenticate;
        return ScaffoldMessenger(
            key: scaffoldMessengerKey,
            child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading:
                      ResponsiveWrapper.of(context).isSmallerThan(TABLET),
                  title: companyLogo(
                      context,
                      authenticate,
                      (order.sales ? "Sales" : "Purchase") +
                          " Order " +
                          (order.orderId != null
                              ? "# ${order.orderId} ${order.orderStatusId.substring(5)}"
                              : "New")),
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.home),
                        onPressed: () => Navigator.pushNamed(context, '/home'))
                  ],
                ),
                drawer: myDrawer(context, authenticate),
                body: BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthProblem)
                        HelperFunctions.showMessage(
                            context, '${state.errorMessage}', Colors.red);
                    },
                    child: BlocListener<SalesOrderBloc, OrderState>(
                        listener: (context, state) {
                          if (state is OrderProblem)
                            HelperFunctions.showMessage(
                                context, '${state.errorMessage}', Colors.red);
                          if (state is OrderSuccess)
                            HelperFunctions.showMessage(
                                context, '${state.message}', Colors.green);
                        },
                        child: BlocConsumer<SalesCartBloc, CartState>(
                            listener: (context, state) {
                          if (state is CartProblem) {
                            HelperFunctions.showMessage(
                                context, '${state.errorMessage}', Colors.green);
                          }
                          if (state is CartLoaded) {
                            HelperFunctions.showMessage(
                                context, '${state.message}', Colors.green);
                          }
                        }, builder: (context, state) {
                          if (state is CartLoading)
                            return Center(child: CircularProgressIndicator());
                          if (state is CartLoaded) {
                            order = state.order;
                          }
                          return Column(children: [
                            SizedBox(height: 20),
                            _orderEntry(repos),
                            _actionButtons(),
                            Center(
                                child: Text(
                                    "Grant total : ${order.grandTotal?.toString()}")),
                            _orderItemList(),
                          ]);
                        })))));
      });
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) authenticate = state.authenticate;
      return ScaffoldMessenger(
          key: scaffoldMessengerKey,
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading:
                    ResponsiveWrapper.of(context).isSmallerThan(TABLET),
                title: companyLogo(
                    context,
                    authenticate,
                    (order.sales ? "Sales" : "Purchase") +
                        " Order " +
                        (order.orderId != null
                            ? "# ${order.orderId} ${order.orderStatusId.substring(5)}"
                            : "New")),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.home),
                      onPressed: () => Navigator.pushNamed(context, '/home'))
                ],
              ),
              drawer: myDrawer(context, authenticate),
              body: BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthProblem)
                      HelperFunctions.showMessage(
                          context, '${state.errorMessage}', Colors.red);
                  },
                  child: BlocListener<PurchOrderBloc, OrderState>(
                      listener: (context, state) {
                        if (state is OrderProblem)
                          HelperFunctions.showMessage(
                              context, '${state.errorMessage}', Colors.red);
                      },
                      child: BlocConsumer<PurchCartBloc, CartState>(
                          listener: (context, state) {
                        if (state is CartProblem) {
                          HelperFunctions.showMessage(
                              context, '${state.errorMessage}', Colors.green);
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
                          order = state.order;
                        }
                        return Column(children: [
                          SizedBox(height: 20),
                          _orderEntry(repos),
                          _actionButtons(),
                          Center(
                              child: Text(
                                  "Grant total : ${order.grandTotal?.toString()}")),
                          _orderItemList(),
                        ]);
                      })))));
    });
  }

  Widget _orderEntry(repos) {
    int columns = ResponsiveWrapper.of(context).isSmallerThan(TABLET) ? 1 : 2;
    double width = columns.toDouble() * 400;
    return Center(
        child: Column(children: [
      Container(
          height: 350 / columns.toDouble(),
          width: width,
          child: Form(
              key: _formKey,
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: GridView.count(
                      crossAxisCount: columns,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: (7),
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
                              width: width / columns.toDouble() - 160,
                              child: DropdownSearch<User>(
                                label: order.sales ? 'Customer' : 'Supplier',
                                dialogMaxWidth: 300,
                                autoFocusSearchBox: true,
                                selectedItem: order.otherUser,
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
                                    order.otherUser = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null)
                                    return "Select ${order.sales ? 'Customer' : 'Supplier'}!";
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            RaisedButton(
                              child: Text('Add New'),
                              onPressed: () async {
                                final User other = await _addOtherPartyDialog(
                                    context, order.sales);
                                if (other != null) {
                                  _userBloc.add(UpdateUser(other));
                                }
                              },
                            )
                          ],
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
                            });
                          },
                          validator: (value) {
                            if (value == null) return "Select Product?";
                            return null;
                          },
                        ),
                        TextFormField(
                          key: Key('price'),
                          decoration: InputDecoration(labelText: 'Price'),
                          controller: _priceController,
                          validator: (value) {
                            if (value.isEmpty) return 'Price?';
                            return null;
                          },
                        ),
                        TextFormField(
                          key: Key('quantity'),
                          decoration: InputDecoration(labelText: 'Quantity'),
                          controller: _quantityController,
                          validator: (value) {
                            if (value.isEmpty) return 'Quantity?';
                            return null;
                          },
                        ),
                      ])))),
    ]));
  }

  Widget _actionButtons() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          RaisedButton(
              key: Key('cancel'),
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          RaisedButton(
              key: Key('clearCart'),
              child: Text('Clear Cart'),
              onPressed: () {
                if (order.orderItems.length > 0) {
                  _cartBloc.add(DeleteFromCart());
                }
              }),
          RaisedButton(
              key: Key('createOrder'),
              child:
                  Text(order.orderId == null ? 'Create Order' : 'Update order'),
              onPressed: () {
                if (order.orderItems.length > 0) {
                  _cartBloc.add(CreateOrderFromCart());
                }
              }),
          RaisedButton(
              key: Key('add'),
              child: Text('Add Cart'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _cartBloc.add(AddToCart(
                      order: Order(
                          sales: order.sales,
                          otherUser: order.otherUser,
                          orderItems: order.orderItems),
                      newItem: OrderItem(
                          productId: _selectedProduct?.productId,
                          description: _selectedProduct.productName,
                          price: Decimal.parse(_priceController.text),
                          quantity: Decimal.parse(_quantityController.text))));
                  setState(() {
                    _selectedProduct = null;
                    _priceController.clear();
                    _quantityController.clear();
                  });
                }
              }),
        ]);
  }

  Widget _orderItemList() {
    List<OrderItem> items = order?.orderItems;

    return Expanded(
        child: CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
            child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
          ),
          title: Row(children: <Widget>[
            Expanded(child: Text("Product", textAlign: TextAlign.center)),
            Expanded(child: Text("Quantity", textAlign: TextAlign.center)),
            Expanded(child: Text("Price", textAlign: TextAlign.center)),
            Expanded(child: Text("SubTotal", textAlign: TextAlign.center)),
          ]),
        )),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return InkWell(
                  onLongPress: () async {
                    _cartBloc.add(DeleteFromCart(index));
                    Navigator.pushNamed(context, '/order',
                        arguments: FormArguments('item deleted', 0, order));
                  },
                  child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Text(items[index]?.orderItemSeqId.toString()),
                      ),
                      title: Row(children: <Widget>[
                        Expanded(
                            child: Text(
                                "${items[index].description}[${items[index].productId}]",
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
                    key: Key('email'),
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
                  RaisedButton(
                      disabledColor: Colors.grey,
                      key: Key('update'),
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
