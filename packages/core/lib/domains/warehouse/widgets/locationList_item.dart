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

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domains.dart';

class LocationListItem extends StatelessWidget {
  const LocationListItem(
      {Key? key,
      required this.location,
      required this.index,
      required this.isPhone})
      : super(key: key);

  final Location location;
  final int index;
  final bool isPhone;

  @override
  Widget build(BuildContext context) {
    final _locationBloc = context.read<LocationBloc>();
    final d = (String s) => Decimal.parse(s);
    Decimal qohTotal = d('0');
    for (Asset asset in location.assets!) {
      qohTotal += asset.quantityOnHand ?? d('0');
    }
    return Material(
        child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Text(location.locationName != null
                  ? "${location.locationName![0]}"
                  : "?"),
            ),
            title: Row(children: <Widget>[
              Expanded(
                  child: Text(
                      "${location.locationName}[${location.locationId}]",
                      key: Key('locName$index'))),
              SizedBox(
                  width: 70,
                  child: Text(
                    "${qohTotal.toString()}",
                    key: Key('qoh$index'),
                    textAlign: TextAlign.center,
                  )),
            ]),
            children: items(location, index),
            trailing: Container(
                width: isPhone ? 100 : 195,
                child: Row(children: [
                  IconButton(
                      key: Key('delete$index'),
                      icon: Icon(Icons.delete_forever),
                      onPressed: () {
                        _locationBloc.add(LocationDelete(location));
                      }),
                  IconButton(
                      key: Key('edit$index'),
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        await showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (BuildContext context) {
                              return BlocProvider.value(
                                  value: _locationBloc,
                                  child: LocationDialog(location));
                            });
                      }),
                ]))));
  }

  List<Widget> items(Location location, int index) {
    int assetCount = 1;
    return List.from(location.assets!.map(
        (e) => Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              SizedBox(width: 50),
              Expanded(
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      maxRadius: 10,
                      child: Text("${(assetCount++).toString()}"),
                    ),
                    title: Row(children: [
                      Expanded(child: Text("${e.assetName}")),
                      Text("${e.statusId}")
                    ]),
                    subtitle: Text("QOH: ${e.quantityOnHand?.toString()} "
                        "ATP: ${e.availableToPromise?.toString()} "
                        "Received:${e.receivedDate}")),
              )
            ])));
  }
}
