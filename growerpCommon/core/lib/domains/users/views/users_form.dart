/*
 * This GrowERP software is in the public domain under CC0 1.0 Universal plus a
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

import 'package:core/domains/common/functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:core/domains/domains.dart';

class UserListForm extends StatelessWidget {
  final Key? key;
  final String userGroupId;
  const UserListForm({
    this.key,
    required this.userGroupId,
  });

  @override
  Widget build(BuildContext context) {
    Widget userList = UsersList(
      key: key,
      userGroupId: userGroupId,
    );
    if (userGroupId == 'GROWERP_M_LEAD') {
      return BlocProvider<LeadBloc>(
          create: (context) => UserBloc(context.read<Object>(), userGroupId,
              BlocProvider.of<AuthBloc>(context))
            ..add(UserFetch()),
          child: userList);
    }
    if (userGroupId == 'GROWERP_M_CUSTOMER') {
      return BlocProvider<CustomerBloc>(
          create: (context) => UserBloc(context.read<Object>(), userGroupId,
              BlocProvider.of<AuthBloc>(context))
            ..add(UserFetch()),
          child: userList);
    }
    if (userGroupId == 'GROWERP_M_SUPPLIER') {
      return BlocProvider<SupplierBloc>(
          create: (context) => UserBloc(context.read<Object>(), userGroupId,
              BlocProvider.of<AuthBloc>(context))
            ..add(UserFetch()),
          child: userList);
    }
    if (userGroupId == 'GROWERP_M_EMPLOYEE') {
      return BlocProvider<EmployeeBloc>(
          create: (context) => UserBloc(context.read<Object>(), userGroupId,
              BlocProvider.of<AuthBloc>(context))
            ..add(UserFetch()),
          child: userList);
    }
    return BlocProvider<AdminBloc>(
        create: (context) => UserBloc(context.read<Object>(), userGroupId,
            BlocProvider.of<AuthBloc>(context))
          ..add(UserFetch()),
        child: userList);
  }
}

class UsersList extends StatefulWidget {
  final String userGroupId;
  final Key? key;

  const UsersList({this.key, required this.userGroupId});

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<UsersList> {
  ScrollController _scrollController = ScrollController();
  double _scrollThreshold = 200.0;
  late UserBloc _userBloc;
  Authenticate authenticate = Authenticate();
  List<User> users = const <User>[];
  bool showSearchField = false;
  String searchString = '';
  bool isLoading = false;
  bool hasReachedMax = false;
  late bool isDeskTop;
  late bool isPhone;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    switch (widget.userGroupId) {
      case "GROWERP_M_ADMIN":
        _userBloc = BlocProvider.of<AdminBloc>(context) as UserBloc
          ..add(UserFetch());
        break;
      case "GROWERP_M_EMPLOYEE":
        _userBloc = BlocProvider.of<EmployeeBloc>(context) as UserBloc
          ..add(UserFetch());
        break;
      case "GROWERP_M_SUPPLIER":
        _userBloc = BlocProvider.of<SupplierBloc>(context) as UserBloc
          ..add(UserFetch());
        break;
      case "GROWERP_M_CUSTOMER":
        _userBloc = BlocProvider.of<CustomerBloc>(context) as UserBloc
          ..add(UserFetch());
        break;
      case "GROWERP_M_LEAD":
        _userBloc = BlocProvider.of<LeadBloc>(context) as UserBloc
          ..add(UserFetch());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    isPhone = ResponsiveWrapper.of(context).isSmallerThan(TABLET);
    isDeskTop = ResponsiveWrapper.of(context).isLargerThan(TABLET);
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state.status == AuthStatus.authenticated)
        authenticate = state.authenticate!;

      Widget showForm(state) {
        return RefreshIndicator(
            onRefresh: (() async {
              _userBloc.add(UserFetch(refresh: true));
            }),
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: hasReachedMax && users.isNotEmpty
                  ? users.length + 1
                  : users.length + 2,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0)
                  return Column(children: [
                    ListTile(
                        onTap: (() {
                          setState(() {
                            showSearchField = !showSearchField;
                            if (!showSearchField) _userBloc.add(UserFetch());
                          });
                        }),
                        leading:
                            Image.asset('assets/images/search.png', height: 30),
                        subtitle: isPhone && !showSearchField
                            ? Text("emailAddress")
                            : null,
                        title: showSearchField
                            ? Row(children: <Widget>[
                                SizedBox(
                                    width: ResponsiveWrapper.of(context)
                                            .isSmallerThan(TABLET)
                                        ? MediaQuery.of(context).size.width -
                                            200
                                        : MediaQuery.of(context).size.width -
                                            350,
                                    child: TextField(
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        hintText:
                                            "search in ID, first and lastname...",
                                      ),
                                      onChanged: ((value) {
                                        searchString = value;
                                      }),
                                      onSubmitted: ((value) {
                                        _userBloc.add(
                                            UserFetch(searchString: value));
                                        setState(() {
                                          showSearchField = false;
                                        });
                                      }),
                                    )),
                                ElevatedButton(
                                    child: Text('Search'),
                                    onPressed: () {
                                      _userBloc.add(UserFetch(
                                          searchString: searchString));
                                      setState(() {
                                        showSearchField = false;
                                      });
                                    })
                              ])
                            : Row(
                                children: <Widget>[
                                  Expanded(child: Text("Name")),
                                  if (isDeskTop)
                                    Expanded(child: Text("login name")),
                                  if (!isPhone) Expanded(child: Text("Email")),
                                  if (isDeskTop)
                                    Expanded(child: Text("Language")),
                                  if (isDeskTop &&
                                      widget.userGroupId !=
                                          "GROWERP_M_EMPLOYEE" &&
                                      widget.userGroupId != "GROWERP_M_ADMIN")
                                    Expanded(
                                        child: Text("Company",
                                            textAlign: TextAlign.center)),
                                  if (isPhone &&
                                      widget.userGroupId !=
                                          "GROWERP_M_EMPLOYEE" &&
                                      widget.userGroupId != "GROWERP_M_ADMIN")
                                    Expanded(child: Text("Company"))
                                ],
                              ),
                        trailing: Text(' ')),
                    Divider(color: Colors.black),
                  ]);
                if (index == 1 && users.isEmpty)
                  return Center(
                      heightFactor: 20,
                      child: Text("no records found!",
                          key: Key('empty'), textAlign: TextAlign.center));
                index -= 1;
                return index >= users.length
                    ? BottomLoader()
                    : Dismissible(
                        key: Key('userItem'),
                        direction: DismissDirection.startToEnd,
                        child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green,
                              child: users[index].image != null
                                  ? Image.memory(users[index].image!)
                                  : Text(users[index].firstName![0]),
                            ),
                            subtitle: isPhone
                                ? Text(
                                    users[index].email!.contains('example.com')
                                        ? " "
                                        : "${users[index].email}",
                                    key: Key("email$index"))
                                : null,
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                  "${users[index].firstName} "
                                  "${users[index].lastName}",
                                  key: Key('name$index'),
                                )),
                                if (isDeskTop)
                                  Expanded(
                                      child: Text(
                                          (!users[index].loginDisabled!
                                              ? "${users[index].loginName}"
                                              : " "),
                                          key: Key('username$index'))),
                                if (!isPhone)
                                  Expanded(
                                      child: Text(
                                    users[index].email!.contains('example.com')
                                        ? " "
                                        : "${users[index].email}",
                                    key: Key('email$index'),
                                  )),
                                if (isDeskTop)
                                  Expanded(
                                      child: Text(
                                    "${users[index].language ?? ''}",
                                    key: Key('language$index'),
                                  )),
                                if (isDeskTop &&
                                    widget.userGroupId !=
                                        "GROWERP_M_EMPLOYEE" &&
                                    widget.userGroupId != "GROWERP_M_ADMIN")
                                  Expanded(
                                    child: Text("${users[index].companyName}",
                                        key: Key('companyName$index'),
                                        textAlign: TextAlign.center),
                                  ),
                                if (isPhone &&
                                    widget.userGroupId !=
                                        "GROWERP_M_EMPLOYEE" &&
                                    widget.userGroupId != "GROWERP_M_ADMIN")
                                  Expanded(
                                      child: Text("${users[index].companyName}",
                                          key: Key('companyName$index'),
                                          textAlign: TextAlign.center))
                              ],
                            ),
                            onTap: () async {
                              await showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return UserDialog(
                                        formArguments: FormArguments(
                                            object: users[index]));
                                  });
                            },
                            trailing: IconButton(
                              key: Key("delete$index"),
                              icon: Icon(Icons.delete_forever),
                              onPressed: () {
                                _userBloc.add(UserDelete(users[index]));
                              },
                            )));
              },
            ));
      }

      dynamic blocListener = (context, state) {
        if (state.status == UserStatus.failure)
          HelperFunctions.showMessage(context, '${state.message}', Colors.red);
        if (state.status == UserStatus.success) {
          HelperFunctions.showMessage(
              context, '${state.message}', Colors.green);
        }
      };

      dynamic blocBuilder = (context, state) {
        if (state.status == UserStatus.failure)
          return FatalErrorForm("Could not load leads!");
        if (state.status == UserStatus.success) {
          isLoading = false;
          users = state.users;
          hasReachedMax = state.hasReachedMax;
          return showForm(state);
        }
        isLoading = true;
        return LoadingIndicator();
      };

      switch (widget.userGroupId) {
        case "GROWERP_M_LEAD":
          return BlocConsumer<LeadBloc, UserState>(
              listener: blocListener, builder: blocBuilder);
        case "GROWERP_M_CUSTOMER":
          return BlocConsumer<CustomerBloc, UserState>(
              listener: blocListener, builder: blocBuilder);
        case "GROWERP_M_ADMIN":
          return BlocConsumer<AdminBloc, UserState>(
              listener: blocListener, builder: blocBuilder);
        case "GROWERP_M_EMPLOYEE":
          return BlocConsumer<EmployeeBloc, UserState>(
              listener: blocListener, builder: blocBuilder);
        case "GROWERP_M_SUPPLIER":
          return BlocConsumer<SupplierBloc, UserState>(
              listener: blocListener, builder: blocBuilder);
        default:
          return Center(
              child: Text(
                  "should NOT show this for userGroup: ${widget.userGroupId}"));
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
    if (currentScroll > 0 && maxScroll - currentScroll <= _scrollThreshold) {
      _userBloc.add(UserFetch(searchString: searchString));
    }
  }
}
