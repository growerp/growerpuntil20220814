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

class EmployeesForm extends StatelessWidget {
  final FormArguments formArguments;
  EmployeesForm(this.formArguments);
  @override
  Widget build(BuildContext context) {
    var a = (formArguments) =>
        (EmployeesPage(formArguments.message, formArguments.object));
    return ShowNavigationRail(a(formArguments), 1, formArguments.object);
  }
}

class EmployeesPage extends StatefulWidget {
  final String message;
  final Authenticate authenticate;
  const EmployeesPage([this.message, this.authenticate]);
  @override
  _EmployeesState createState() => _EmployeesState(message, authenticate);
}

class _EmployeesState extends State<EmployeesPage> {
  final String message;
  final Authenticate authenticate;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  _EmployeesState([this.message, this.authenticate]) {
    HelperFunctions.showTopMessage(scaffoldMessengerKey, message);
  }
  @override
  Widget build(BuildContext context) {
    Authenticate authenticate = this.authenticate;
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) authenticate = state.authenticate;
      return ScaffoldMessenger(
          key: scaffoldMessengerKey,
          child: Scaffold(
              appBar: AppBar(
                  title: companyLogo(context, authenticate, 'Employees'),
                  automaticallyImplyLeading:
                      ResponsiveWrapper.of(context).isSmallerThan(TABLET)),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/employee',
                      arguments:
                          FormArguments('Enter new employee information...'));
                },
                tooltip: 'Add new user',
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
                  child: userList(authenticate))));
    });
  }

  Widget userList(authenticate) {
    List<User> users = authenticate?.company?.employees;
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
                Expanded(child: Text("Group", textAlign: TextAlign.center)),
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
                      context, '/employee',
                      arguments: FormArguments(null, 0, users[index]));
                  setState(() {
                    if (result is Authenticate)
                      users = result.company.employees;
                  });
                  HelperFunctions.showMessage(
                      context,
                      'User ${users[index].firstName} '
                      '${users[index].lastName} modified',
                      Colors.green);
                },
                onLongPress: () async {
                  bool result = await confirmDialog(
                      context,
                      "${users[index].firstName} ${users[index].lastName}",
                      "Delete this user?");
                  if (result) {
                    BlocProvider.of<AuthBloc>(context)
                        .add(DeleteEmployee(users[index]));
                    Navigator.pushNamed(context, '/employees',
                        arguments:
                            FormArguments('Employee deleted', authenticate));
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
                      Expanded(
                          child: Text("${users[index].groupDescription}",
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
