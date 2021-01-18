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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:models/models.dart';
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
    return BlocProvider(
        create: (context) => CartBloc(
            BlocProvider.of<AuthBloc>(context),
            BlocProvider.of<OrderBloc>(context),
            BlocProvider.of<ProductBloc>(context),
            BlocProvider.of<CategoryBloc>(context),
            BlocProvider.of<CustomerBloc>(context),
            BlocProvider.of<SupplierBloc>(context))
          ..add(LoadCart(formArguments.object)),
        child: ShowNavigationRail(a(formArguments), formArguments.tab));
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
  final Order orderIn;
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  bool loading = false;
  Order order;
  Authenticate authenticate;
  List<Product> products;
  List<User> otherParties;
  Product _selectedProduct;
  User _selectedOtherParty;
  bool sales;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  _MyOrderState(this.message, this.orderIn) {
    HelperFunctions.showTopMessage(scaffoldMessengerKey, message);
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      if (state is CartLoaded) {
        authenticate = state.authenticate;
        if (orderIn.customerPartyId == authenticate.company.partyId)
          sales = false;
        if (orderIn.supplierPartyId == authenticate.company.partyId)
          sales = true;
        otherParties = sales ? state.customers : state.suppliers;
        order = state.order;
        products = state.products;
        return ScaffoldMessenger(
            key: scaffoldMessengerKey,
            child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading:
                      ResponsiveWrapper.of(context).isSmallerThan(TABLET),
                  title: companyLogo(context, authenticate,
                      (sales ? 'Sales' : 'Purchase') + " Order detail"),
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
                    child: BlocListener<OrderBloc, OrderState>(
                        listener: (context, state) {
                          if (state is OrderProblem)
                            HelperFunctions.showMessage(
                                context, '${state.errorMessage}', Colors.red);
                        },
                        child: BlocConsumer<CartBloc, CartState>(
                            listener: (context, state) {
                          if (state is CartProblem) {
                            loading = false;
                            HelperFunctions.showMessage(
                                context, '${state.errorMessage}', Colors.green);
                          } else if (state is CartLoading) {
                            loading = true;
                            HelperFunctions.showMessage(
                                context, '${state.message}', Colors.green);
                            return Center(child: CircularProgressIndicator());
                          } else if (state is CartLoaded) {
                            loading = true;
                            HelperFunctions.showMessage(
                                context, '${state.message}', Colors.green);
                            setState(() {
                              _selectedProduct = null;
                              _priceController.clear();
                              _quantityController.clear();
                            });
                          }
                        }, builder: (context, state) {
                          if (state is CartLoading)
                            return Center(child: CircularProgressIndicator());
                          else
                            return _orderItemList();
                        })))));
      }
      return Center(child: CircularProgressIndicator());
    });
  }

  Widget _orderItemList() {
    List<OrderItem> items = order?.orderItems;
    if (sales)
      _selectedOtherParty ??= order?.customerPartyId != null &&
              otherParties != null
          ? otherParties.firstWhere((x) => order.customerPartyId == x.partyId)
          : null;
    else
      _selectedOtherParty ??= order?.supplierPartyId != null &&
              otherParties != null
          ? otherParties.firstWhere((x) => order.supplierPartyId == x.partyId)
          : null;
    loading = false;
    // phone has a singe column, tablet and larger 2
    int columns = ResponsiveWrapper.of(context).isSmallerThan(TABLET) ? 1 : 2;
    double width = columns.toDouble() * 400;
    return Center(
        child: Column(children: [
      Container(
          height: 450 / columns.toDouble(),
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
                                child: DropdownButtonFormField<User>(
                                  key: Key('dropDownOtherParty'),
                                  hint: Text(sales ? 'Customer' : 'Supplier'),
                                  value: _selectedOtherParty,
                                  validator: (value) =>
                                      value == null ? 'field required' : null,
                                  items: otherParties?.map((x) {
                                    return DropdownMenuItem<User>(
                                        child: Text(
                                            "${x.lastName} ${x.firstName}"),
                                        value: x);
                                  })?.toList(),
                                  onChanged: (User newValue) {
                                    setState(() {
                                      _selectedOtherParty = newValue;
                                    });
                                  },
                                  isExpanded: true,
                                )),
                            SizedBox(width: 10),
                            RaisedButton(
                              child: Text('Add New'),
                              onPressed: () async {
                                final User other =
                                    await _addOtherPartyDialog(context, sales);
                                if (other != null) {
                                  BlocProvider.of<UserBloc>(context)
                                      .add(UpdateUser(other, null));
                                }
                              },
                            )
                          ],
                        ),
                        DropdownButtonFormField<Product>(
                          key: Key('dropDownProd'),
                          hint: Text('Product'),
                          value: _selectedProduct,
                          validator: (value) =>
                              value == null ? 'field required' : null,
                          items: products?.map((product) {
                            return DropdownMenuItem<Product>(
                                child: Text("${product?.productName}"),
                                value: product);
                          })?.toList(),
                          onChanged: (Product newValue) {
                            setState(() {
                              _priceController
                                ..text = newValue.price.toString();
                              _selectedProduct = newValue;
                            });
                          },
                          isExpanded: true,
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
                        RaisedButton(
                            key: Key('Confirm Order'),
                            child: Text('confirm'),
                            onPressed: () {
                              if (order.orderItems.length > 0 && !loading) {
                                BlocProvider.of<CartBloc>(context)
                                    .add(ConfirmCart());
                              }
                            }),
                        RaisedButton(
                            key: Key('add'),
                            child: Text('Add'),
                            onPressed: () {
                              if (_formKey.currentState.validate() &&
                                  !loading) {
                                BlocProvider.of<CartBloc>(context).add(
                                    UpdateCart(Order(
                                        customerPartyId: sales
                                            ? _selectedOtherParty.partyId
                                            : authenticate.company.partyId,
                                        supplierPartyId: sales
                                            ? authenticate.company.partyId
                                            : _selectedOtherParty.partyId,
                                        orderItems: [
                                      OrderItem(
                                          productId:
                                              _selectedProduct?.productId,
                                          price: Decimal.parse(
                                              _priceController.text),
                                          quantity: Decimal.parse(
                                              _quantityController.text))
                                    ])));
                              }
                            }),
//                Text("Grant total : ${order.grandTotal?.toString()}"),
                      ])))),
      Expanded(
          child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
              ),
              title: Row(
                children: <Widget>[
                  Expanded(child: Text("Product", textAlign: TextAlign.center)),
                  Expanded(
                      child: Text("Quantity", textAlign: TextAlign.center)),
                  Expanded(child: Text("Price", textAlign: TextAlign.center)),
                  Expanded(
                      child: Text("SubTotal", textAlign: TextAlign.center)),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return InkWell(
                    onLongPress: () async {
                      BlocProvider.of<CartBloc>(context)
                          .add(DeleteItemCart(index));
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
                    ));
              },
              childCount: items == null ? 0 : items?.length,
            ),
          ),
        ],
      )),
    ]));
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
                          Navigator.of(context).pop(updatedUser);
                        }
                      })
                ]))),
      );
    },
  );
}
