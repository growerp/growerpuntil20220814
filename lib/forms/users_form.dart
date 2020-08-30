import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/@models.dart';
import '../blocs/@blocs.dart';
import '../services/repos.dart';
import '../helper_functions.dart';
import '../routing_constants.dart';
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
                  Navigator.pop(context, 'Delete successfull,');
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
                Expanded(child: Text("First Name")),
                Expanded(child: Text("Last Name")),
                Expanded(child: Text("Email")),
                Expanded(child: Text("Group")),
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
                      Expanded(child: Text(users[index].firstName ?? '')),
                      Expanded(child: Text(users[index].lastName ?? '')),
                      Expanded(child: Text(users[index].email ?? '')),
                      Expanded(
                          child: Text(users[index].groupDescription ?? '')),
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
