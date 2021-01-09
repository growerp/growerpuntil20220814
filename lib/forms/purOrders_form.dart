/*
 * This software is in the public domain under CC0 1.0 Universal plus a
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:models/models.dart';
import 'package:core/blocs/@blocs.dart';
import 'package:core/helper_functions.dart';
import 'package:core/widgets/@widgets.dart';
import 'package:printing/printing.dart';

class PurOrdersForm extends StatelessWidget {
  final FormArguments formArguments;
  PurOrdersForm(this.formArguments);
  @override
  Widget build(BuildContext context) {
    var a = (formArguments) =>
        (PurOrdersFormHeader(formArguments.message, formArguments.object));
    return ShowNavigationRail(a(formArguments), 5, formArguments.object);
  }
}

class PurOrdersFormHeader extends StatefulWidget {
  final String message;
  final Authenticate authenticate;
  const PurOrdersFormHeader([this.message, this.authenticate]);
  @override
  _PurOrdersFormStateHeader createState() =>
      _PurOrdersFormStateHeader(message, authenticate);
}

class _PurOrdersFormStateHeader extends State<PurOrdersFormHeader> {
  final String message;
  final Authenticate authenticate;
  int _selectedIndex;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  _PurOrdersFormStateHeader([this.message, this.authenticate]) {
    HelperFunctions.showTopMessage(scaffoldMessengerKey, message);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Authenticate authenticate = this.authenticate;
    _selectedIndex = _selectedIndex ?? 0;
    Crm crm;
    List<Order> orders;
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) authenticate = state.authenticate;
      return ScaffoldMessenger(
          key: scaffoldMessengerKey,
          child: DefaultTabController(
              length: 2,
              child: Scaffold(
                  appBar: AppBar(
                      bottom:
                          !ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                              ? TabBar(
                                  onTap: (index) {
                                    _selectedIndex = index;
                                  },
                                  labelPadding: EdgeInsets.all(10.0),
                                  labelColor: Colors.black,
                                  unselectedLabelColor: Colors.white,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  indicator: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      color: Colors.white),
                                  tabs: [
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text("Purchase Orders")),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text("Suppliers")),
                                  ],
                                )
                              : null,
                      title: companyLogo(context, authenticate, 'Purchasing'),
                      automaticallyImplyLeading:
                          ResponsiveWrapper.of(context).isSmallerThan(TABLET)),
                  bottomNavigationBar:
                      ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                          ? BottomNavigationBar(
                              items: const <BottomNavigationBarItem>[
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.home),
                                  label: 'Purchase Orders',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.school),
                                  label: 'Suppliers',
                                ),
                              ],
                              currentIndex: _selectedIndex,
                              selectedItemColor: Colors.amber[800],
                              onTap: _onItemTapped,
                            )
                          : null,
                  floatingActionButton: FloatingActionButton(
                    onPressed: () async {
                      dynamic order, user;
                      _selectedIndex == 0
                          ? order = await Navigator.pushNamed(context, '/order',
                              arguments: FormArguments(
                                  'Enter new puchase order...',
                                  5,
                                  Order(
                                      customerPartyId:
                                          authenticate.company.partyId)))
                          : user = await Navigator.pushNamed(
                              context, '/crmUser',
                              arguments: FormArguments(
                                  'Enter new suppier...',
                                  4,
                                  User(
                                      userGroupId: 'GROWERP_M_SUPPLIER',
                                      groupDescription: 'Supplier')));
                      setState(() {
                        if (order != null) orders.add(order);
                        if (user != null) crm.suppliers.add(user);
                      });
                    },
                    tooltip: 'Add new',
                    child: Icon(Icons.add),
                  ),
                  drawer: myDrawer(context, authenticate),
                  body: BlocListener<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthProblem)
                          HelperFunctions.showMessage(
                              context, '${state.errorMessage}', Colors.red);
                      },
                      child: BlocConsumer<OrderBloc, OrderState>(
                          listener: (context, state) {
                        if (state is OrderProblem)
                          HelperFunctions.showMessage(
                              context, '${state.errorMessage}', Colors.red);
                        if (state is OrderLoading)
                          HelperFunctions.showMessage(
                              context, '${state.message}', Colors.green);
                        if (state is OrderLoaded)
                          HelperFunctions.showMessage(
                              context, '${state.message}', Colors.green);
                      }, builder: (context, state) {
                        if (state is OrderLoading)
                          return Center(child: CircularProgressIndicator());
                        if (state is OrderLoaded)
                          orders = state.orders
                              .where((x) =>
                                  x.customerPartyId ==
                                  authenticate.company.partyId)
                              .toList();
                        return BlocConsumer<CrmBloc, CrmState>(
                            listener: (context, state) {
                          if (state is CrmProblem)
                            HelperFunctions.showMessage(
                                context, '${state.errorMessage}', Colors.red);
                          if (state is CrmLoaded)
                            HelperFunctions.showMessage(
                                context, '${state.message}', Colors.green);
                          if (state is CrmLoading)
                            HelperFunctions.showMessage(
                                context, '${state.message}', Colors.green);
                        }, builder: (context, state) {
                          if (state is CrmLoaded) {
                            crm = state.crm;
                          }
                          return ResponsiveWrapper.of(context)
                                  .isSmallerThan(TABLET)
                              ? Center(
                                  child: _selectedIndex == 0
                                      ? orderList(orders)
                                      : crmList(crm?.suppliers))
                              : TabBarView(
                                  children: [
                                    orderList(orders),
                                    crmList(crm?.suppliers)
                                  ],
                                );
                        });
                      })))));
    });
  }

  Widget orderList(orders) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          // you could add any widget
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
            ),
            title: Row(
              children: <Widget>[
                Expanded(child: Text("Supplier", textAlign: TextAlign.center)),
                if (!ResponsiveWrapper.of(context).isSmallerThan(TABLET))
                  Expanded(child: Text("Email", textAlign: TextAlign.center)),
                Expanded(child: Text("Date", textAlign: TextAlign.center)),
                Expanded(child: Text("Total", textAlign: TextAlign.center)),
                Expanded(child: Text("Status", textAlign: TextAlign.center)),
                if (!ResponsiveWrapper.of(context).isSmallerThan(TABLET))
                  Expanded(child: Text("#items", textAlign: TextAlign.center)),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return InkWell(
                onTap: () async {
                  dynamic result = await Navigator.pushNamed(context, '/order',
                      arguments: FormArguments(null, 5, orders[index]));
                  setState(() {
                    if (result is List) orders = result;
                  });
                  HelperFunctions.showMessage(
                      context,
                      'Order ${orders[index].firstName} '
                      '${orders[index].lastName} modified',
                      Colors.green);
                },
                onLongPress: () async {
                  bool result = await confirmDialog(
                      context,
                      "${orders[index].firstName} ${orders[index].lastName}",
                      "Delete this order?");
                  if (result) {
                    BlocProvider.of<OrderBloc>(context)
                        .add(CancelOrder(orders, orders[index].orderId));
                    Navigator.pushNamed(context, '/orders',
                        arguments:
                            FormArguments('Order deleted', 0, authenticate));
                  }
                },
                child: ListTile(
                  leading: InkWell(
                      onTap: () async {
                        bool result = await confirmDialog(
                            context,
                            "${orders[index].orderStatusId} changes to "
                                "${nextOrderStatus[orders[index].orderStatusId]}",
                            "Proceed?");
                        if (result &&
                            nextOrderStatus[orders[index].orderStatusId] !=
                                "No Change") {
                          BlocProvider.of<OrderBloc>(context)
                              .add(NextStatButtonPressed(orders[index]));
                        }
                      },
                      child: Tooltip(
                          message: "click to go to next order status",
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Text(orders[index]?.orderStatusId[0]),
                          ))),
                  title: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text("${orders[index].lastName}, "
                              "${orders[index].firstName}")),
                      if (!ResponsiveWrapper.of(context).isSmallerThan(TABLET))
                        Expanded(
                            child: Text("${orders[index].email}",
                                textAlign: TextAlign.center)),
                      Expanded(
                          child: Text(
                              "${orders[index].placedDate.toString().substring(0, 11)}",
                              textAlign: TextAlign.center)),
                      Expanded(
                          child: Text("${orders[index].grandTotal}",
                              textAlign: TextAlign.center)),
                      Expanded(
                          child: Text("${orders[index].orderStatusId}",
                              textAlign: TextAlign.center)),
                      if (!ResponsiveWrapper.of(context).isSmallerThan(TABLET))
                        Expanded(
                            child: Text("${orders[index].orderItems?.length}",
                                textAlign: TextAlign.center)),
                    ],
                  ),
                ),
              );
            },
            childCount: orders == null ? 0 : orders?.length,
          ),
        ),
      ],
    );
  }

  Widget crmList(users) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          // you could add any widget
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
            ),
            title: Row(
              children: <Widget>[
                Expanded(child: Text("Name", textAlign: TextAlign.center)),
                if (!ResponsiveWrapper.of(context).isSmallerThan(DESKTOP))
                  Expanded(
                      child: Text("login name", textAlign: TextAlign.center)),
                Expanded(child: Text("Email", textAlign: TextAlign.center)),
                if (!ResponsiveWrapper.of(context).isSmallerThan(TABLET))
                  Expanded(
                      child: Text("Language", textAlign: TextAlign.center)),
                if (!ResponsiveWrapper.of(context).isSmallerThan(DESKTOP))
                  Expanded(child: Text("Company", textAlign: TextAlign.center)),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return InkWell(
                onTap: () async {
                  dynamic result = await Navigator.pushNamed(
                      context, '/crmUser',
                      arguments: FormArguments(null, 5, users[index]));
                  if (result is User)
                    setState(() {
                      HelperFunctions.showMessage(
                          context,
                          'User ${users[index].firstName} '
                          '${users[index].lastName} modified',
                          Colors.green);
                    });
                },
                onLongPress: () async {
                  bool result = await confirmDialog(
                      context,
                      "${users[index].firstName} ${users[index].lastName}",
                      "Delete this ${_selectedIndex == 1 ? 'Lead' : 'Customer'}");
                  if (result) {
                    BlocProvider.of<CrmBloc>(context)
                        .add(DeleteCrmUser(users[index]));
                    setState(() {
                      HelperFunctions.showMessage(
                          context,
                          "${_selectedIndex == 1 ? 'Lead' : 'Customer'} "
                          "${users[index].firstName} ${users[index].lastName}"
                          "deleted",
                          Colors.green);
                    });
                  }
                },
                child: ListTile(
                  //return  ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: users[index]?.image != null
                        ? Image.memory(users[index]?.image)
                        : Text(users[index]?.firstName[0]),
                  ),
                  title: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text("${users[index].lastName}, "
                              "${users[index].firstName} "
                              "[${users[index].partyId}]")),
                      if (!ResponsiveWrapper.of(context).isSmallerThan(DESKTOP))
                        Expanded(
                            child: Text("${users[index].name}",
                                textAlign: TextAlign.center)),
                      Expanded(
                          child: Text("${users[index].email}",
                              textAlign: TextAlign.center)),
                      if (!ResponsiveWrapper.of(context).isSmallerThan(TABLET))
                        Expanded(
                            child: Text("${users[index].language}",
                                textAlign: TextAlign.center)),
                      if (!ResponsiveWrapper.of(context).isSmallerThan(DESKTOP))
                        Expanded(
                            child: Text("${users[index].companyName}",
                                textAlign: TextAlign.center)),
                    ],
                  ),
                ),
              );
            },
            childCount: users == null ? 0 : users?.length,
          ),
        ),
      ],
    );
  }
}
