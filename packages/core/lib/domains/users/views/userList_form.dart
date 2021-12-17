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

import '../../../api_repository.dart';

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
    switch (userGroupId) {
      case 'GROWERP_M_LEAD':
        return BlocProvider<LeadBloc>(
            create: (context) => UserBloc(context.read<APIRepository>(),
                userGroupId, BlocProvider.of<AuthBloc>(context))
              ..add(UserFetch()),
            child: userList);
      case 'GROWERP_M_CUSTOMER':
        return BlocProvider<CustomerBloc>(
            create: (context) => UserBloc(context.read<APIRepository>(),
                userGroupId, BlocProvider.of<AuthBloc>(context))
              ..add(UserFetch()),
            child: userList);
      case 'GROWERP_M_SUPPLIER':
        return BlocProvider<SupplierBloc>(
            create: (context) => UserBloc(context.read<APIRepository>(),
                userGroupId, BlocProvider.of<AuthBloc>(context))
              ..add(UserFetch()),
            child: userList);
      case 'GROWERP_M_EMPLOYEE':
        return BlocProvider<EmployeeBloc>(
            create: (context) => UserBloc(context.read<APIRepository>(),
                userGroupId, BlocProvider.of<AuthBloc>(context))
              ..add(UserFetch()),
            child: userList);
      case 'GROWERP_M_ADMIN':
        return BlocProvider<AdminBloc>(
            create: (context) => UserBloc(context.read<APIRepository>(),
                userGroupId, BlocProvider.of<AuthBloc>(context))
              ..add(UserFetch()),
            child: userList);
      default:
        return Center(
            child: Text("user usergroup: '$userGroupId' not allowed"));
    }
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
  late bool isPhone;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    switch (widget.userGroupId) {
      case "GROWERP_M_ADMIN":
        _userBloc = BlocProvider.of<AdminBloc>(context) as UserBloc;
        break;
      case "GROWERP_M_EMPLOYEE":
        _userBloc = BlocProvider.of<EmployeeBloc>(context) as UserBloc;
        break;
      case "GROWERP_M_SUPPLIER":
        _userBloc = BlocProvider.of<SupplierBloc>(context) as UserBloc;
        break;
      case "GROWERP_M_CUSTOMER":
        _userBloc = BlocProvider.of<CustomerBloc>(context) as UserBloc;
        break;
      case "GROWERP_M_LEAD":
        _userBloc = BlocProvider.of<LeadBloc>(context) as UserBloc;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    isPhone = ResponsiveWrapper.of(context).isSmallerThan(TABLET);
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
                    UserListHeader(
                        isPhone: isPhone,
                        userGroupId: widget.userGroupId,
                        userBloc: _userBloc),
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
                        child: UserListItem(
                            user: users[index],
                            index: index,
                            userGroupId: widget.userGroupId,
                            userBloc: _userBloc,
                            isDeskTop: !isPhone));
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
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                  key: Key("addNew"),
                  onPressed: () async {
                    await showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (BuildContext context) {
                          return BlocProvider.value(
                              value: _userBloc,
                              child: UserDialog(
                                  user: User(
                                userGroupId: widget.userGroupId,
                              )));
                        });
                  },
                  tooltip: 'Add New',
                  child: Icon(Icons.add)),
              body: showForm(state));
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
