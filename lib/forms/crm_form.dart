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
    Crm crm;
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
                                  context, '/crmUser',
                                  arguments: FormArguments(
                                      'Enter new Lead...',
                                      0,
                                      User(
                                          userGroupId: 'GROWERP_M_LEAD',
                                          groupDescription: 'New Lead')))
                              : userCust = await Navigator.pushNamed(
                                  context, '/crmUser',
                                  arguments: FormArguments(
                                      'Enter new custmer...',
                                      0,
                                      User(
                                          userGroupId: 'GROWERP_M_CUSTOMER',
                                          groupDescription: 'New Customer')));
                      setState(() {
                        if (opportunity != null)
                          crm.opportunities.add(opportunity);
                        if (userLead != null) crm.leads.add(userLead);
                        if (userCust != null) crm.customers.add(userCust);
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
                        if (state is AuthLoading)
                          HelperFunctions.showMessage(
                              context, '${state.message}', Colors.red);
                      },
                      child: BlocConsumer<CrmBloc, CrmState>(
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
                                    ? opportunityList(crm?.opportunities)
                                    : _selectedIndex == 1
                                        ? crmList(crm?.leads)
                                        : crmList(crm?.customers))
                            : TabBarView(
                                children: [
                                  opportunityList(crm?.opportunities),
                                  crmList(crm?.leads),
                                  crmList(crm?.customers)
                                ],
                              );
                      })))));
    });
  }

  Widget opportunityList(List<Opportunity> opportunities) {
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
                Expanded(child: Text("Oppt.Name", textAlign: TextAlign.center)),
                if (!ResponsiveWrapper.of(context).isSmallerThan(DESKTOP))
                  Expanded(
                      child: Text("Est. Amount", textAlign: TextAlign.center)),
                if (!ResponsiveWrapper.of(context).isSmallerThan(DESKTOP))
                  Expanded(
                      child: Text("Est. Probability %",
                          textAlign: TextAlign.center)),
                Expanded(child: Text("Lead Name", textAlign: TextAlign.center)),
                Expanded(child: Text("Email", textAlign: TextAlign.center)),
                if (!ResponsiveWrapper.of(context).isSmallerThan(TABLET))
                  Expanded(child: Text("Stage", textAlign: TextAlign.center)),
                if (!ResponsiveWrapper.of(context).isSmallerThan(DESKTOP))
                  Expanded(
                      child: Text("Next Step", textAlign: TextAlign.center)),
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
                      context, '/opportunity',
                      arguments:
                          FormArguments(null, null, opportunities[index]));
                  if (result is Opportunity)
                    setState(() {
                      HelperFunctions.showMessage(
                          context,
                          'Opportunity ${opportunities[index].opportunityName} '
                          'modified',
                          Colors.green);
                    });
                },
                onLongPress: () async {
                  bool result = await confirmDialog(
                      context,
                      "Opportunity: ${opportunities[index].opportunityName}\n",
                      "Delete this Opportunity?");
                  if (result) {
                    BlocProvider.of<CrmBloc>(context)
                        .add(DeleteOpportunity(opportunities[index]));
                  }
                },
                child: ListTile(
                  //return  ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(""),
                  ),
                  title: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text("${opportunities[index].opportunityName}",
                              textAlign: TextAlign.center)),
                      if (!ResponsiveWrapper.of(context).isSmallerThan(DESKTOP))
                        Expanded(
                            child: Text(
                                "${opportunities[index].estAmount.toString()}",
                                textAlign: TextAlign.center)),
                      if (!ResponsiveWrapper.of(context).isSmallerThan(DESKTOP))
                        Expanded(
                            child: Text(
                                "${opportunities[index].estProbability.toString()}",
                                textAlign: TextAlign.center)),
                      Expanded(
                          child: Text("${opportunities[index].fullName}",
                              textAlign: TextAlign.center)),
                      Expanded(
                          child: Text("${opportunities[index].email}",
                              textAlign: TextAlign.center)),
                      Text("${opportunities[index].stageId}",
                          textAlign: TextAlign.center),
                      if (!ResponsiveWrapper.of(context).isSmallerThan(DESKTOP))
                        Expanded(
                            child: Text("${opportunities[index].nextStep}",
                                textAlign: TextAlign.center)),
                    ],
                  ),
                ),
              );
            },
            childCount: opportunities == null ? 0 : opportunities?.length,
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
                      arguments: FormArguments(null, 0, users[index]));
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
