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

import '@forms.dart';

class CrmForm extends StatelessWidget {
  final FormArguments formArguments;
  CrmForm(this.formArguments);
  @override
  Widget build(BuildContext context) {
    var a = (formArguments) =>
        (CrmFormHeader(formArguments.message, formArguments.object));
    return ShowNavigationRail(a(formArguments), 2, formArguments.object);
  }
}

class CrmFormHeader extends StatefulWidget {
  final String message;
  final Authenticate authenticate;
  const CrmFormHeader([this.message, this.authenticate]);
  @override
  _CrmFormStateHeader createState() =>
      _CrmFormStateHeader(message, authenticate);
}

class _CrmFormStateHeader extends State<CrmFormHeader> {
  final String message;
  final Authenticate authenticate;
  int _selectedIndex;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  _CrmFormStateHeader([this.message, this.authenticate]) {
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
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) authenticate = state.authenticate;
      return ScaffoldMessenger(
          key: scaffoldMessengerKey,
          child: DefaultTabController(
              length: 3,
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
                                        child: Text("Opportunity")),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text("Leads")),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text("Customers")),
                                  ],
                                )
                              : null,
                      title: companyLogo(context, authenticate, 'Crm List'),
                      automaticallyImplyLeading:
                          ResponsiveWrapper.of(context).isSmallerThan(TABLET)),
                  bottomNavigationBar:
                      ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                          ? BottomNavigationBar(
                              items: const <BottomNavigationBarItem>[
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.home),
                                  label: 'Opportunity',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.business),
                                  label: 'Leads',
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
                      dynamic opportunity, userLead, userCust;
                      _selectedIndex == 0
                          ? opportunity = await Navigator.pushNamed(
                              context, '/opportunity',
                              arguments:
                                  FormArguments('Enter new opportunity...'))
                          : _selectedIndex == 1
                              ? userLead = await Navigator.pushNamed(
                                  context, '/user',
                                  arguments: FormArguments(
                                      'Enter new Lead...',
                                      2,
                                      User(
                                          userGroupId: 'GROWERP_M_LEAD',
                                          groupDescription: 'New Lead')))
                              : userCust = await Navigator.pushNamed(
                                  context, '/user',
                                  arguments: FormArguments(
                                      'Enter new custmer...',
                                      2,
                                      User(
                                          userGroupId: 'GROWERP_M_CUSTOMER',
                                          groupDescription: 'New Customer')));
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
                        if (state is AuthLoading)
                          HelperFunctions.showMessage(
                              context, '${state.message}', Colors.red);
                      },
                      child: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                          ? Center(
                              child: _selectedIndex == 0
                                  ? OpportunitiesForm()
                                  : _selectedIndex == 1
                                      ? UsersForm("GROWERP_M_LEAD", 2)
                                      : UsersForm("GROWERP_M_CUSTOMER", 2))
                          : TabBarView(
                              children: [
                                OpportunitiesForm(),
                                UsersForm("GROWERP_M_LEAD", 2),
                                UsersForm("GROWERP_M_CUSTOMER", 2)
                              ],
                            )))));
    });
  }
}
