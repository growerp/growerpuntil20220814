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
import '../catalog.dart';

class AssetListItem extends StatelessWidget {
  const AssetListItem({Key? key, required this.asset, required this.index})
      : super(key: key);

  final Asset asset;
  final int index;

  @override
  Widget build(BuildContext context) {
    final _assetBloc = context.read<AssetBloc>();
    return Material(
        child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Text(
                  asset.assetName != null ? "${asset.assetName![0]}" : "?"),
            ),
            title: Row(
              children: <Widget>[
                Expanded(
                    child: Text("${asset.assetName}", key: Key('name$index'))),
                if (!ResponsiveWrapper.of(context).isSmallerThan(TABLET))
                  Expanded(
                      child: Text("${asset.statusId}",
                          key: Key('statusId$index'),
                          textAlign: TextAlign.center)),
                Expanded(
                    child: Text("${asset.product!.productName}",
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
                        value: _assetBloc, child: AssetDialog(asset));
                  });
            },
            trailing: IconButton(
              key: Key('delete$index'),
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                _assetBloc.add(AssetDelete(asset));
              },
            )));
  }
}
