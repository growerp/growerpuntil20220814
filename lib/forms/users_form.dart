import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/blocs/@blocs.dart';
import 'package:core/widgets/@widgets.dart';
import 'package:core/helper_functions.dart';
import 'package:models/models.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class UsersForm extends StatefulWidget {
  final String userGroupId;
  final int tab;
  final Key key;
  const UsersForm({this.key, this.userGroupId, this.tab});
  @override
  _UsersState createState() => _UsersState(userGroupId, tab);
}

class _UsersState extends State<UsersForm> {
  final String userGroupId;
  final int tab;
  final _scrollController = ScrollController();
  double _scrollThreshold = 200.0;
  UserBloc _userBloc;
  var blocName;
  Authenticate authenticate;
  List<User> users;
  bool hasReachedMax;
  int limit;
  _UsersState(this.userGroupId, this.tab);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      limit = (MediaQuery.of(context).size.height / 35).round();
      switch (userGroupId) {
        case "GROWERP_M_ADMIN":
          _userBloc = BlocProvider.of<AdminBloc>(context)
            ..add(FetchUser(limit: limit));
          break;
        case "GROWERP_M_EMPLOYEE":
          _userBloc = BlocProvider.of<EmployeeBloc>(context)
            ..add(FetchUser(limit: limit));
          break;
        case "GROWERP_M_SUPPLIER":
          _userBloc = BlocProvider.of<SupplierBloc>(context)
            ..add(FetchUser(limit: limit));
          break;
        case "GROWERP_M_CUSTOMER":
          _userBloc = BlocProvider.of<CustomerBloc>(context)
            ..add(FetchUser(limit: limit));
          break;
        case "GROWERP_M_LEAD":
          _userBloc = BlocProvider.of<LeadBloc>(context)
            ..add(FetchUser(limit: limit));
          break;
      }
    });
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) authenticate = state?.authenticate;

      Widget showForm() {
        if (users == null) return LoadingIndicator();
        if (users.isEmpty) return Center(child: Text('no users'));
        return ListView.builder(
          itemCount: hasReachedMax ? users.length + 1 : users.length + 2,
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0)
              return ListTile(
                  onTap: null,
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    //Image.asset("images/search.png", height: 35),
                  ),
                  title: Column(children: [
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Text("Name", textAlign: TextAlign.center)),
                        if (!ResponsiveWrapper.of(context)
                            .isSmallerThan(DESKTOP))
                          Expanded(
                              child: Text("login name",
                                  textAlign: TextAlign.center)),
                        Expanded(
                            child: Text("Email", textAlign: TextAlign.center)),
                        if (!ResponsiveWrapper.of(context)
                            .isSmallerThan(TABLET))
                          Expanded(
                              child: Text("Language",
                                  textAlign: TextAlign.center)),
                        if (!ResponsiveWrapper.of(context)
                                .isSmallerThan(DESKTOP) &&
                            userGroupId != "GROWERP_M_EMPLOYEE" &&
                            userGroupId != "GROWERP_M_ADMIN")
                          Expanded(
                              child:
                                  Text("Company", textAlign: TextAlign.center)),
                      ],
                    ),
                    Divider(color: Colors.black),
                  ]),
                  trailing: Text(' '));
            index -= 1;
            return index >= users.length
                ? BottomLoader()
                : Dismissible(
                    key: Key(users[index].partyId),
                    direction: DismissDirection.startToEnd,
                    child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: users[index]?.image != null
                              ? Image.memory(users[index]?.image)
                              : Text(users[index]?.firstName[0]),
                        ),
                        title: Row(
                          children: <Widget>[
                            Expanded(
                                child: Text("${users[index].firstName}, "
                                    "${users[index].lastName}")),
                            if (!ResponsiveWrapper.of(context)
                                .isSmallerThan(DESKTOP))
                              Expanded(
                                  child: Text("${users[index].name}",
                                      textAlign: TextAlign.center)),
                            Expanded(
                                child: Text("${users[index].email}",
                                    textAlign: TextAlign.center)),
                            if (!ResponsiveWrapper.of(context)
                                .isSmallerThan(TABLET))
                              Expanded(
                                  child: Text("${users[index].language}",
                                      textAlign: TextAlign.center)),
                            if (!ResponsiveWrapper.of(context)
                                    .isSmallerThan(DESKTOP) &&
                                userGroupId != "GROWERP_M_EMPLOYEE" &&
                                userGroupId != "GROWERP_M_ADMIN")
                              Expanded(
                                  child: Text("${users[index].companyName}",
                                      textAlign: TextAlign.center)),
                          ],
                        ),
                        onTap: () async {
                          await Navigator.pushNamed(context, '/user',
                              arguments:
                                  FormArguments(null, tab, users[index]));
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.delete_forever),
                          onPressed: () {
                            _userBloc.add(DeleteUser(users[index]));
                          },
                        )));
          },
        );
      }

      switch (userGroupId) {
        case "GROWERP_M_LEAD":
          return BlocConsumer<LeadBloc, UserState>(listener: (context, state) {
            if (state is UserProblem)
              HelperFunctions.showMessage(
                  context, '${state.errorMessage}', Colors.red);
            if (state is UserSuccess)
              HelperFunctions.showMessage(
                  context, '${state.message}', Colors.green);
          }, builder: (context, state) {
            if (state is UserSuccess) {
              users = state.users;
              hasReachedMax = state.hasReachedMax;
            }
            return showForm();
          });
        case "GROWERP_M_CUSTOMER":
          return BlocConsumer<CustomerBloc, UserState>(
              listener: (context, state) {
            if (state is UserProblem)
              HelperFunctions.showMessage(
                  context, '${state.errorMessage}', Colors.red);
            if (state is UserSuccess)
              HelperFunctions.showMessage(
                  context, '${state.message}', Colors.green);
          }, builder: (context, state) {
            if (state is UserSuccess) {
              users = state.users;
              hasReachedMax = state.hasReachedMax;
            }
            return showForm();
          });
        case "GROWERP_M_ADMIN":
          return BlocConsumer<AdminBloc, UserState>(listener: (context, state) {
            if (state is UserProblem)
              HelperFunctions.showMessage(
                  context, '${state.errorMessage}', Colors.red);
            if (state is UserSuccess)
              HelperFunctions.showMessage(
                  context, '${state.message}', Colors.green);
          }, builder: (context, state) {
            if (state is UserSuccess) {
              users = state.users;
              hasReachedMax = state.hasReachedMax;
            }
            return showForm();
          });
        case "GROWERP_M_EMPLOYEE":
          return BlocConsumer<EmployeeBloc, UserState>(
              listener: (context, state) {
            if (state is UserProblem)
              HelperFunctions.showMessage(
                  context, '${state.errorMessage}', Colors.red);
            if (state is UserSuccess)
              HelperFunctions.showMessage(
                  context, '${state.message}', Colors.green);
          }, builder: (context, state) {
            if (state is UserSuccess) {
              users = state.users;
              hasReachedMax = state.hasReachedMax;
            }
            return showForm();
          });
        case "GROWERP_M_SUPPLIER":
          return BlocConsumer<SupplierBloc, UserState>(
              listener: (context, state) {
            if (state is UserProblem)
              HelperFunctions.showMessage(
                  context, '${state.errorMessage}', Colors.red);
            if (state is UserSuccess)
              HelperFunctions.showMessage(
                  context, '${state.message}', Colors.green);
          }, builder: (context, state) {
            if (state is UserSuccess) {
              users = state.users;
              hasReachedMax = state.hasReachedMax;
            }
            return showForm();
          });
      }
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
      _userBloc.add(FetchUser(limit: limit));
    }
  }
}
