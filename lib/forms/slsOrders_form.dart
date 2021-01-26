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
import 'package:models/@models.dart';
import 'package:core/blocs/@blocs.dart';
import 'package:core/helper_functions.dart';
import 'package:core/widgets/@widgets.dart';
import 'package:printing/printing.dart';

import '@forms.dart';

class SlsOrdersForm extends StatelessWidget {
  final FormArguments formArguments;
  SlsOrdersForm(this.formArguments);
  @override
  Widget build(BuildContext context) {
    var a = (formArguments) =>
        (SlsOrdersFormHeader(formArguments.message, formArguments.object));
    return ShowNavigationRail(a(formArguments), 4, formArguments.object);
  }
}

class SlsOrdersFormHeader extends StatefulWidget {
  final String message;
  final Authenticate authenticate;
  const SlsOrdersFormHeader([this.message, this.authenticate]);
  @override
  _SlsOrdersFormStateHeader createState() =>
      _SlsOrdersFormStateHeader(message, authenticate);
}

class _SlsOrdersFormStateHeader extends State<SlsOrdersFormHeader> {
  final String message;
  final Authenticate authenticate;
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  _SlsOrdersFormStateHeader([this.message, this.authenticate]) {
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
                                        child: Text("Sales Orders")),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text("Customers")),
                                  ],
                                )
                              : null,
                      title: companyLogo(
                          context, authenticate, 'Sales Order List'),
                      automaticallyImplyLeading:
                          ResponsiveWrapper.of(context).isSmallerThan(TABLET)),
                  bottomNavigationBar:
                      ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                          ? BottomNavigationBar(
                              items: const <BottomNavigationBarItem>[
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.home),
                                  label: 'Sales Orders',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.school),
                                  label: 'Customers',
                                ),
                              ],
                              currentIndex: _selectedIndex,
                              selectedItemColor: Colors.amber[800],
                              onTap: _onItemTapped,
                            )
                          : null,
                  floatingActionButton: FloatingActionButton(
                    onPressed: () async {
                      _selectedIndex == 0
                          ? await Navigator.pushNamed(context, '/order',
                              arguments: FormArguments(
                                  'Enter a new sales order...',
                                  4,
                                  Order(sales: true, orderItems: [])))
                          : await Navigator.pushNamed(context, '/user',
                              arguments: FormArguments(
                                  'Enter a new customer...',
                                  4,
                                  User(
                                      userGroupId: 'GROWERP_M_CUSTOMER',
                                      groupDescription: 'Customer')));
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
                      child: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                          ? Center(
                              child: _selectedIndex == 0
                                  ? OrdersForm(sales: true)
                                  : UsersForm(
                                      userGroupId: "GROWERP_M_CUSTOMER",
                                      tab: 4))
                          : TabBarView(
                              children: [
                                OrdersForm(sales: true),
                                UsersForm(
                                    userGroupId: "GROWERP_M_CUSTOMER", tab: 4)
                              ],
                            )))));
    });
  }
}
