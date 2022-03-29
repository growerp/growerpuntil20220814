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
import 'package:global_configuration/global_configuration.dart';
import '../findoc.dart';

class FinDocListHeader extends StatelessWidget {
  const FinDocListHeader({
    Key? key,
    required this.sales,
    required this.docType,
    required this.isPhone,
    required this.finDocBloc,
  }) : super(key: key);
  final bool sales;
  final FinDocType docType;
  final bool isPhone;
  final FinDocBloc finDocBloc;

  @override
  Widget build(BuildContext context) {
    String classificationId = GlobalConfiguration().get("classificationId");
    String searchString = '';
    return Material(
        child: ListTile(
            leading: GestureDetector(
                key: Key('search'),
                onTap: (() {
                  if (finDocBloc.state.search) {
                    finDocBloc.add(FinDocSearchOff());
                    finDocBloc.add(FinDocFetch(refresh: true));
                  } else
                    finDocBloc.add(FinDocSearchOn());
                }),
                child: Image.asset(
                  'assets/images/search.png',
                  height: 30,
                )),
            title: finDocBloc.state.search
                ? Row(children: <Widget>[
                    Expanded(
                        child: TextField(
                      key: Key('searchField'),
                      autofocus: true,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          hintText: 'search with ID'),
                      onChanged: ((value) {
                        searchString = value;
                      }),
                    )),
                    ElevatedButton(
                        key: Key('searchButton'),
                        child: Text('search'),
                        onPressed: () {
                          finDocBloc
                              .add(FinDocFetch(searchString: searchString));
                          searchString = '';
                        })
                  ])
                : Row(children: <Widget>[
                    SizedBox(width: 80, child: Text(docType.toString())),
                    SizedBox(width: 10),
                    Expanded(
                        child: Text((sales ? "Customer" : "Supplier") +
                            ' name & Company')),
                    if (!isPhone && docType != FinDocType.payment)
                      SizedBox(
                          width: 80,
                          child: Text("#items", textAlign: TextAlign.left)),
                  ]),
            subtitle: Row(children: <Widget>[
              SizedBox(
                  width: 80,
                  child: Text(classificationId == 'AppHotel'
                      ? 'Reserv. Date'
                      : 'Creation Date')),
              SizedBox(width: 76, child: Text("Total")),
              SizedBox(width: 90, child: Text("Status")),
              if (!isPhone) Expanded(child: Text("Email Address")),
              if (!isPhone) Expanded(child: Text("$docType description")),
            ]),
            trailing: SizedBox(width: isPhone ? 40 : 195)));
  }
}
