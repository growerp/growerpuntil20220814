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

import 'package:core/domains/domains.dart';
import 'package:flutter/material.dart';

class UserListHeader extends StatelessWidget {
  const UserListHeader({
    Key? key,
    required this.userGroup,
    required this.isPhone,
    required this.userBloc,
  }) : super(key: key);
  final UserGroup userGroup;
  final bool isPhone;
  final UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    String searchString = '';
    return Material(
        child: ListTile(
            leading: GestureDetector(
                key: Key('search'),
                onTap: (() {
                  if (userBloc.state.search) {
                    userBloc.add(UserSearchOff());
                    userBloc.add(UserFetch(refresh: true));
                  } else
                    userBloc.add(UserSearchOn());
                }),
                child: Image.asset(
                  'assets/images/search.png',
                  height: 30,
                )),
            title: userBloc.state.search
                ? Row(children: <Widget>[
                    Expanded(
                        child: TextField(
                      key: Key('searchField'),
                      autofocus: true,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          hintText: 'enter first or last name'),
                      onChanged: ((value) {
                        searchString = value;
                      }),
                    )),
                    ElevatedButton(
                        key: Key('searchButton'),
                        child: Text('search'),
                        onPressed: () {
                          userBloc.add(UserFetch(searchString: searchString));
                          searchString = '';
                        })
                  ])
                : Row(
                    children: <Widget>[
                      Expanded(child: Text("Name")),
                      if (!isPhone) Expanded(child: Text("login name")),
                      if (!isPhone) Expanded(child: Text("Email")),
                      if (!isPhone) Expanded(child: Text("Language")),
                      if (!isPhone &&
                          userGroup != UserGroup.Employee &&
                          userGroup != UserGroup.Admin)
                        Expanded(
                            child:
                                Text("Company", textAlign: TextAlign.center)),
                      if (isPhone &&
                          userGroup != UserGroup.Employee &&
                          userGroup != UserGroup.Admin)
                        Expanded(child: Text("Company"))
                    ],
                  ),
            trailing: Text(' ')));
  }
}
