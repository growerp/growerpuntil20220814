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
import '../models/@models.dart';
import '../blocs/@blocs.dart';
import '../helper_functions.dart';
import '../routing_constants.dart';
import '../widgets/@widgets.dart';

class UsersForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FormHeader(UsersFormHeader());
  }
}

class UsersFormHeader extends StatefulWidget {
  @override
  State<UsersFormHeader> createState() => _UsersFormStateHeader();
}

class _UsersFormStateHeader extends State<UsersFormHeader> {
  @override
  Widget build(BuildContext context) {
    Authenticate authenticate;
    return Scaffold(
        appBar: AppBar(
            title: const Text('User List'),
            automaticallyImplyLeading:
                ResponsiveWrapper.of(context).isSmallerThan(TABLET)),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            dynamic user =
                await Navigator.pushNamed(context, UserRoute, arguments: null);
            setState(() {
              if (user?.partyId != null)
                authenticate.company.employees.add(user);
            });
          },
          tooltip: 'Add new user',
          child: Icon(Icons.add),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
          if (state is AuthProblem) {
            HelperFunctions.showMessage(
                context, '${state.errorMessage}', Colors.red);
          }
          if (state is AuthAuthenticated) {
            HelperFunctions.showMessage(
                context, '${state.message}', Colors.green);
          }
        }, builder: (context, state) {
          if (state is AuthAuthenticated) authenticate = state.authenticate;
          return userList(context, authenticate);
        }));
  }

  Widget userList(context, Authenticate authenticate) {
    List<User> users = authenticate.company.employees;
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
                  Expanded(child: Text("Country", textAlign: TextAlign.center)),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return InkWell(
                onTap: () async {
                  dynamic user = await Navigator.pushNamed(context, UserRoute,
                      arguments: users[index]);
                  setState(() {
                    if (user != null)
                      users.replaceRange(index, index + 1, [user]);
                  });
                },
                onLongPress: () async {
                  bool result = await confirmDialog(
                      context,
                      "${users[index].firstName} ${users[index].lastName}",
                      "Delete this user?");
                  if (result) {
                    BlocProvider.of<AuthBloc>(context)
                        .add(DeleteUser(authenticate, users[index].partyId));
                    setState(() {
                      users.removeAt(index);
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
                      Expanded(
                          child: Text("${users[index].groupDescription}",
                              textAlign: TextAlign.center)),
                      if (!ResponsiveWrapper.of(context).isSmallerThan(TABLET))
                        Expanded(
                            child: Text("${users[index].language}",
                                textAlign: TextAlign.center)),
                      if (!ResponsiveWrapper.of(context).isSmallerThan(DESKTOP))
                        Expanded(
                            child: Text("${users[index].country}",
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
