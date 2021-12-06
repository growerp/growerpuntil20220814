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

class LocationListItem extends StatelessWidget {
  const LocationListItem(
      {Key? key, required this.location, required this.index})
      : super(key: key);

  final Location location;
  final int index;

  @override
  Widget build(BuildContext context) {
    final _locationBloc = BlocProvider.of<LocationBloc>(context);
    return Material(
        child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Text(location.locationName != null
                  ? "${location.locationName![0]}"
                  : "?"),
            ),
            title: Row(
              children: <Widget>[
                Expanded(
                    child: Text("${location.locationName}",
                        key: Key('name$index'))),
                if (!ResponsiveWrapper.of(context).isSmallerThan(TABLET))
                  Expanded(
                      child: Text("${location.assets![0].assetName}",
                          key: Key('statusId$index'),
                          textAlign: TextAlign.center)),
                Expanded(
                    child: Text("${location.assets![0].product?.productName}",
                        key: Key('product$index'),
                        textAlign: TextAlign.center)),
              ],
            ),
            onTap: () async {
              await showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (BuildContext context) {
                    return BlocProvider.value(
                        value: _locationBloc, child: LocationDialog(location));
                  });
            },
            trailing: IconButton(
              key: Key('delete$index'),
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                _locationBloc.add(LocationDelete(location));
              },
            )));
  }
}
