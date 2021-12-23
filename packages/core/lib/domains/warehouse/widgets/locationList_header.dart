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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import '../warehouse.dart';

class LocationListHeader extends StatelessWidget {
  const LocationListHeader({Key? key, required this.search}) : super(key: key);
  final bool search;

  @override
  Widget build(BuildContext context) {
    final _locationBloc = BlocProvider.of<LocationBloc>(context);
    String searchString = '';
    return Material(
        child: Column(children: [
      ListTile(
          onTap: (() {
            _locationBloc
                .add(search ? LocationSearchOff() : LocationSearchOn());
          }),
          leading: Image.asset('assets/images/search.png', height: 30),
          title: search
              ? Row(children: <Widget>[
                  SizedBox(
                      width: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                          ? MediaQuery.of(context).size.width - 250
                          : MediaQuery.of(context).size.width - 350,
                      child: TextField(
                        textInputAction: TextInputAction.go,
                        autofocus: true,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          hintText: "search in ID, name and description...",
                        ),
                        onChanged: ((value) {
                          searchString = value;
                        }),
                        onSubmitted: ((value) {
                          _locationBloc.add(LocationFetch(searchString: value));
                          _locationBloc.add(search
                              ? LocationSearchOff()
                              : LocationSearchOn());
                        }),
                      )),
                  ElevatedButton(
                      child: Text('Search'),
                      onPressed: () {
                        _locationBloc
                            .add(LocationFetch(searchString: searchString));
                      })
                ])
              : Row(children: <Widget>[
                  Expanded(child: Text("Loc.Name[ID]")),
                  SizedBox(width: 80, child: Text("Quantity\nOn Hand")),
                ]),
          subtitle: Text('Product Name'),
          trailing: SizedBox(width: 50)),
      Divider(color: Colors.black),
    ]));
  }
}
