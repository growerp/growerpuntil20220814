import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/blocs/@blocs.dart';
import 'package:core/widgets/@widgets.dart';
import 'package:core/helper_functions.dart';
import 'package:models/@models.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class OrdersForm extends StatefulWidget {
  final sales;
  const OrdersForm({this.sales});
  @override
  _OrdersState createState() => _OrdersState(this.sales);
}

class _OrdersState extends State<OrdersForm> {
  final bool sales;
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  OrderBloc _orderBloc;
  Authenticate authenticate;
  int tab;
  int limit = 20;
  bool showSearchField;
  String searchString;

  _OrdersState(this.sales);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    showSearchField = false;
  }

  @override
  Widget build(BuildContext context) {
    tab = sales ? 4 : 5;
    setState(() {
      limit = (MediaQuery.of(context).size.height / 35).round();
      if (sales)
        _orderBloc = BlocProvider.of<SalesOrderBloc>(context)
          ..add(FetchOrder(limit: limit));
      else
        _orderBloc = BlocProvider.of<PurchOrderBloc>(context)
          ..add(FetchOrder(limit: limit));
    });
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) {
        authenticate = state?.authenticate;
        if (sales)
          return BlocConsumer<SalesOrderBloc, OrderState>(
              listener: (context, state) {
            if (state is OrderProblem)
              HelperFunctions.showMessage(
                  context, '${state.errorMessage}', Colors.red);
            if (state is OrderSuccess)
              HelperFunctions.showMessage(
                  context, '${state.message}', Colors.green);
          }, builder: (context, state) {
            if (state is OrderSuccess)
              return orderPage(state.orders, state.hasReachedMax);
            return Center(child: CircularProgressIndicator());
          });
        else
          return BlocConsumer<PurchOrderBloc, OrderState>(
              listener: (context, state) {
            if (state is OrderProblem)
              HelperFunctions.showMessage(
                  context, '${state.errorMessage}', Colors.red);
            if (state is OrderSuccess) {
              HelperFunctions.showMessage(
                  context, '${state.message}', Colors.green);
              HelperFunctions.showMessage(
                  context, '${state.errorMessage}', Colors.red);
            }
            if (state is OrderLoading)
              HelperFunctions.showMessage(
                  context, '${state.message}', Colors.green);
          }, builder: (context, state) {
            List<Order> orders = [];
            bool hasReachedMax = true;
            if (state is OrderSuccess) {
              orders = state.orders;
              hasReachedMax = state.hasReachedMax;
            }
            if (state is OrderLoading)
              return Center(child: CircularProgressIndicator());
            return orderPage(orders, hasReachedMax);
          });
      }
      return Container(child: Center(child: Text("Not Authorized!")));
    });
  }

  Widget orderPage(orders, hasReachedMax) {
    return ListView.builder(
        itemCount: hasReachedMax && orders.isNotEmpty
            ? orders.length + 1
            : orders.length + 2,
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0)
            return ListTile(
                onTap: (() {
                  setState(() {
                    showSearchField = !showSearchField;
                  });
                }),
                leading: Image.asset('assets/images/search.png', height: 30),
                title: showSearchField
                    ? Row(children: <Widget>[
                        SizedBox(
                            width: ResponsiveWrapper.of(context)
                                    .isSmallerThan(TABLET)
                                ? MediaQuery.of(context).size.width - 250
                                : MediaQuery.of(context).size.width - 350,
                            child: TextField(
                              textInputAction: TextInputAction.go,
                              autofocus: true,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                hintText: "search in ID, " +
                                    (sales ? "customer" : "supplier"),
                              ),
                              onChanged: ((value) {
                                searchString = value;
                              }),
                              onSubmitted: ((value) {
                                _orderBloc.add(
                                    FetchOrder(search: value, limit: limit));
                                setState(() {
                                  showSearchField = !showSearchField;
                                });
                              }),
                            )),
                        ElevatedButton(
                            child: Text('Search'),
                            onPressed: () {
                              _orderBloc.add(FetchOrder(
                                  search: searchString, limit: limit));
                            })
                      ])
                    : Column(children: [
                        Row(children: <Widget>[
                          Expanded(child: Text("Order ID")),
                          Expanded(
                              child: Text(sales ? "Customer" : "Supplier")),
                          if (!ResponsiveWrapper.of(context)
                              .isSmallerThan(TABLET))
                            Expanded(child: Text("Email")),
                          Expanded(child: Text("Date")),
                          if (!ResponsiveWrapper.of(context)
                              .isSmallerThan(TABLET))
                            Expanded(child: Text("Total")),
                          Expanded(
                              child:
                                  Text("Status", textAlign: TextAlign.center)),
                          if (!ResponsiveWrapper.of(context)
                              .isSmallerThan(TABLET))
                            Expanded(
                                child: Text("#items",
                                    textAlign: TextAlign.center)),
                        ]),
                        Divider(color: Colors.black),
                      ]),
                trailing: Text('                     '));
          if (index == 1 && orders.isEmpty && searchString != null)
            return Center(
                heightFactor: 20,
                child: Text("no records found!", textAlign: TextAlign.center));
          index -= 1;
          return index >= orders.length
              ? BottomLoader()
              : Dismissible(
                  key: Key(orders[index].orderId),
                  direction: DismissDirection.startToEnd,
                  child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Text("${orders[index].otherUser.lastName[0]}"),
                      ),
                      title: Row(
                        children: <Widget>[
                          Expanded(child: Text("${orders[index].orderId}")),
                          Expanded(
                              child:
                                  Text("${orders[index].otherUser.firstName}, "
                                      "${orders[index].otherUser.lastName}")),
                          if (!ResponsiveWrapper.of(context)
                              .isSmallerThan(TABLET))
                            Expanded(
                                child: Text(
                              "${orders[index].otherUser.email}",
                            )),
                          Expanded(
                              child: Text(
                            "${orders[index].placedDate.toString().substring(0, 11)}",
                          )),
                          if (!ResponsiveWrapper.of(context)
                              .isSmallerThan(TABLET))
                            Expanded(
                                child: Text("${orders[index].grandTotal}",
                                    textAlign: TextAlign.center)),
                          Expanded(
                              child: Text(
                                  "${orders[index].orderStatusId.substring(5)}",
                                  textAlign: TextAlign.center)),
                          if (!ResponsiveWrapper.of(context)
                              .isSmallerThan(TABLET))
                            Expanded(
                                child: Text(
                                    "${orders[index].orderItems?.length}",
                                    textAlign: TextAlign.center)),
                        ],
                      ),
                      onTap: () async {
                        await Navigator.pushNamed(context, '/order',
                            arguments: FormArguments(
                                menuIndex: tab, object: orders[index]));
                      },
                      trailing: Container(
                          width: 100,
                          child: Visibility(
                              visible: orders[index].orderStatusId !=
                                      'OrderCancelled' &&
                                  orders[index].orderStatusId !=
                                      'OrderCompleted',
                              child: Row(children: [
                                IconButton(
                                  icon: Icon(Icons.delete_forever),
                                  tooltip: 'Cancel Order',
                                  onPressed: () {
                                    orders[index].orderStatusId =
                                        'OrderCancelled';
                                    _orderBloc.add(UpdateOrder(orders[index]));
                                  },
                                ),
                                IconButton(
                                    icon: Icon(Icons.arrow_upward),
                                    tooltip: orders[index].orderStatusId ==
                                            'OrderOpen'
                                        ? 'Place Order'
                                        : orders[index].orderStatusId ==
                                                'OrderPlaced'
                                            ? 'Approve order'
                                            : 'Complete order',
                                    onPressed: () {
                                      orders[index].orderStatusId =
                                          nextOrderStatus[
                                              orders[index].orderStatusId];
                                      _orderBloc
                                          .add(UpdateOrder(orders[index]));
                                    })
                              ])))));
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _orderBloc.add(FetchOrder(limit: limit, search: searchString));
    }
  }
}
