import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/blocs/@blocs.dart';
import 'package:core/widgets/@widgets.dart';
import 'package:models/models.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class UsersForm extends StatefulWidget {
  final String userGroupId;
  final int tab;
  const UsersForm(this.userGroupId, this.tab);
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
    print("====usersform with userGroupId: $userGroupId");
    setState(() {
      limit = (MediaQuery.of(context).size.height / 35).round();
      switch (userGroupId) {
        case "GROWERP_M_ADMIN":
          _userBloc = BlocProvider.of<AdminBloc>(context)
            ..add(FetchUser(userGroupId: userGroupId, limit: limit));
          break;
        case "GROWERP_M_EMPLOYEE":
          _userBloc = BlocProvider.of<EmployeeBloc>(context)
            ..add(FetchUser(userGroupId: userGroupId, limit: limit));
          break;
        case "GROWERP_M_LEAD":
          _userBloc = BlocProvider.of<LeadBloc>(context)
            ..add(FetchUser(userGroupId: userGroupId, limit: limit));
          break;
        case "GROWERP_M_CUSTOMER":
          _userBloc = BlocProvider.of<CustomerBloc>(context)
            ..add(FetchUser(userGroupId: userGroupId, limit: limit));
          break;
        case "GROWERP_M_SUPPLIER":
          _userBloc = BlocProvider.of<SupplierBloc>(context)
            ..add(FetchUser(userGroupId: userGroupId, limit: limit));
      }
    });
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      print("=======usersform state; $state");
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
                            .isSmallerThan(DESKTOP))
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
                                child: Text("${users[index].lastName}, "
                                    "${users[index].firstName} "
                                    "[${users[index].partyId}]")),
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
                                .isSmallerThan(DESKTOP))
                              Expanded(
                                  child: Text("${users[index].companyName}",
                                      textAlign: TextAlign.center)),
                          ],
                        ),
                        onTap: () async {
                          dynamic result = await Navigator.pushNamed(
                              context, '/user',
                              arguments:
                                  FormArguments(null, tab, users[index]));
                          setState(() {
                            if (result is User)
                              users.replaceRange(index, index + 1, [result]);
                          });
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.delete_forever),
                          onPressed: () {
                            _userBloc.add(DeleteUser(users[index]));
                            setState(() {
                              users.removeAt(index);
                            });
                          },
                        )));
          },
        );
      }

      if (userGroupId == "GROWERP_M_ADMIN") {
        return BlocBuilder<AdminBloc, UserState>(builder: (context, state) {
          if (state is UserFetchSuccess) {
            users = state.users;
            hasReachedMax = state.hasReachedMax;
          }
          return showForm();
        });
      } else if (userGroupId == "GROWERP_M_EMPLOYEE") {
        return BlocBuilder<EmployeeBloc, UserState>(builder: (context, state) {
          if (state is UserFetchSuccess) {
            users = state.users;
            hasReachedMax = state.hasReachedMax;
          }
          return showForm();
        });
      } else if (userGroupId == "GROWERP_M_LEAD") {
        return BlocBuilder<LeadBloc, UserState>(builder: (context, state) {
          if (state is UserFetchSuccess) {
            users = state.users;
            hasReachedMax = state.hasReachedMax;
          }
          return showForm();
        });
      } else if (userGroupId == "GROWERP_M_CUSTOMER") {
        return BlocBuilder<CustomerBloc, UserState>(builder: (context, state) {
          if (state is UserFetchSuccess) {
            users = state.users;
            hasReachedMax = state.hasReachedMax;
          }
          return showForm();
        });
      } else if (userGroupId == "GROWERP_M_SUPPLIER") {
        return BlocBuilder<SupplierBloc, UserState>(builder: (context, state) {
          if (state is UserFetchSuccess) {
            users = state.users;
            hasReachedMax = state.hasReachedMax;
          }
          return showForm();
        });
      } else
        return Container(
            child: Center(
          child: Text("????2222"),
        ));
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
    print(
        "=====onScrol cur: ${_scrollController.position.maxScrollExtent - _scrollController.position.pixels} treshold: _${_scrollThreshold}");
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _userBloc.add(FetchUser(userGroupId: userGroupId, limit: limit));
    }
  }
}
