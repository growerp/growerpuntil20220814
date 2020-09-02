import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../models/@models.dart';
import '../blocs/@blocs.dart';
import '../services/repos.dart';
import '../helper_functions.dart';
import '../routing_constants.dart';
import '../widgets/@widgets.dart';
import '@forms.dart';

class UsersForm extends StatefulWidget {
  @override
  _UsersFormState createState() => _UsersFormState();
}

class _UsersFormState extends State<UsersForm> {
  List<User> users;
  @override
  Widget build(BuildContext context) {
    Authenticate authenticate;
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is! AuthAuthenticated) return NoAccessForm('Userlist');
      if (state is AuthAuthenticated) authenticate = state.authenticate;
      return BlocProvider(
          create: (_) => UsersBloc(
              repos: context.repository<Repos>(),
              companyPartyId: authenticate?.company?.partyId)
            ..add(LoadUser()),
          child: Scaffold(
              appBar: AppBar(title: const Text('User List')),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  dynamic user = await Navigator.pushNamed(context, UserRoute);
                  setState(() {
                    users.add(user);
                  });
                },
                tooltip: 'Add new user',
                child: Icon(Icons.add),
              ), // This trailing comma makes auto-formatting nicer for build methods.

              body: BlocListener<UsersBloc, UsersState>(listener:
                  (context, state) {
                if (state is UsersError) {
                  HelperFunctions.showMessage(
                      context, '${state.errorMessage}', Colors.red);
                }
                if (state is UserUpdateSuccess) {
                  HelperFunctions.showMessage(
                      context, 'Update success', Colors.green);
                }
                if (state is UserDeleteSuccess) {
                  HelperFunctions.showMessage(
                      context, 'Delete success', Colors.green);
                }
              }, child:
                  BlocBuilder<UsersBloc, UsersState>(builder: (context, state) {
                if (state is UsersLoading)
                  return Center(child: CircularProgressIndicator());
                if (state is UsersLoaded) users = state?.users;
                return userList(context, users);
              }))));
    });
  }

  Widget userList(context, List<User> users) {
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
                      arguments: users[index].partyId);
                  setState(() {
                    users.replaceRange(index, index + 1, [user]);
                  });
                },
                onLongPress: () async {
                  bool result = await confirmDialog(
                      context,
                      "${users[index].firstName} ${users[index].lastName}",
                      "Delete this user?");
                  if (result) {
                    BlocProvider.of<UsersBloc>(context)
                        .add(DeleteUser(users[index].partyId));
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
                        : Text(users[index].firstName[0]),
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
