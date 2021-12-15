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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import '../findoc.dart';

class FinDocListItem extends StatelessWidget {
  const FinDocListItem({
    Key? key,
    required this.finDoc,
    required this.index,
    required this.sales,
    required this.docType,
    required this.isPhone,
    required this.onlyRental,
    required this.finDocBloc,
  }) : super(key: key);

  final FinDoc finDoc;
  final int index;
  final bool sales;
  final String docType;
  final bool isPhone;
  final bool onlyRental;
  final FinDocBloc finDocBloc;

  @override
  Widget build(BuildContext context) {
    String classificationId = GlobalConfiguration().get("classificationId");
    Widget buttons() {
      return Row(children: [
        Visibility(
            visible: !isPhone,
            child: Row(children: [
              IconButton(
                key: Key('delete$index'),
                icon: Icon(Icons.delete_forever),
                tooltip: 'Cancel ${finDoc.docType}',
                onPressed: () {
                  finDocBloc.add(FinDocUpdate(
                      finDoc.copyWith(statusId: 'FinDocCancelled')));
                },
              ),
              IconButton(
                key: Key('print$index'),
                icon: Icon(Icons.print),
                tooltip: 'PDF/Print ${finDoc.docType}',
                onPressed: () async {
                  await Navigator.pushNamed(context, '/printer',
                      arguments: finDoc);
                },
              ),
            ])),
        IconButton(
            key: Key('nextStatus$index'),
            icon: Icon(Icons.arrow_upward),
            tooltip: nextFinDocStatus[finDocStatusValues[finDoc.statusId!]!],
            onPressed: () {
              finDocBloc.add(FinDocUpdate(finDoc.copyWith(
                  statusId: nextFinDocStatus[finDoc.statusId!])));
            }),
        Visibility(
            visible: finDoc.docType == 'order',
            child: IconButton(
              icon: Icon(Icons.edit),
              key: Key('edit$index'),
              tooltip: 'Edit ${finDoc.docType}',
              onPressed: () async {
                await showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context) {
                      return BlocProvider.value(
                          value: finDocBloc,
                          child: onlyRental == true
                              ? ReservationDialog(finDoc: finDoc)
                              : FinDocDialog(finDoc: finDoc));
                    });
              },
            )),
      ]);
    }

    return Material(
        child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Text(finDoc.otherUser?.companyName == null
                  ? ''
                  : finDoc.otherUser!.companyName![0]),
            ),
            title: Row(
              children: <Widget>[
                SizedBox(
                    width: 80,
                    child: Text("${finDoc.id()}", key: Key('id$index'))),
                SizedBox(width: 10),
                Expanded(
                    child: Text(
                        "${finDoc.otherUser!.firstName ?? ''} "
                        "${finDoc.otherUser!.lastName ?? ''}\n"
                        "${finDoc.otherUser!.companyName ?? ''}",
                        key: Key("otherUser$index"))),
                if (!isPhone && docType != 'payment')
                  SizedBox(width: 80, child: Text("${finDoc.items.length}")),
              ],
            ),
            subtitle: Row(children: <Widget>[
              SizedBox(
                  width: 80,
                  child: Text(classificationId == 'AppHotel'
                      ? finDoc.items[0].rentalFromDate
                          .toString()
                          .substring(0, 10)
                      : "${finDoc.creationDate?.toString().substring(0, 11)}")),
              SizedBox(
                  width: 76,
                  child: Text("${finDoc.grandTotal}",
                      key: Key("grandTotal$index"))),
              SizedBox(
                  width: 90,
                  child: Text("${finDoc.statusName(classificationId)}",
                      key: Key("statusId$index"))),
              if (!isPhone)
                Expanded(
                    child: Text(
                  "${finDoc.otherUser!.email ?? ''}",
                  key: Key('email$index'),
                )),
              if (!isPhone)
                Expanded(
                    child: Text(
                  "${finDoc.description ?? ''}",
                  key: Key('description$index'),
                )),
            ]),
            children: items(finDoc, index),
            trailing: Container(
                width: isPhone ? 100 : 195,
                child: docType == 'shipment'
                    ? (sales
                        ? IconButton(
                            key: Key('nextStatus$index'),
                            icon: Icon(Icons.send),
                            tooltip: nextFinDocStatus[
                                finDocStatusValues[finDoc.statusId!]!],
                            onPressed: () {
                              finDocBloc.add(FinDocUpdate(finDoc.copyWith(
                                  statusId:
                                      nextFinDocStatus[finDoc.statusId!])));
                            })
                        : IconButton(
                            key: Key('nextStatus$index'),
                            icon: Icon(Icons.call_received),
                            onPressed: () async {
                              await showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BlocProvider.value(
                                        value: finDocBloc,
                                        child: ShipmentReceiveDialog(finDoc));
                                  });
                            }))
                    : classificationId == 'AppHotel' &&
                            finDoc.statusId == 'FinDocApproved'
                        ? IconButton(
                            key: Key('nextStatus$index'),
                            icon: Icon(Icons.check_box_sharp),
                            tooltip: nextFinDocStatus[
                                finDocStatusValues[finDoc.statusId!]!],
                            onPressed: () {
                              finDocBloc.add(FinDocUpdate(finDoc.copyWith(
                                  statusId:
                                      nextFinDocStatus[finDoc.statusId!])));
                            })
                        : Visibility(
                            visible:
                                finDocStatusFixed[finDoc.statusId!] ?? true,
                            child: buttons(),
                          ))));
  }

  List<Widget> items(FinDoc findoc, int index) {
    return List.from(finDoc.items.map((e) =>
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SizedBox(width: 50),
          Expanded(
              child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    maxRadius: 10,
                    child: Text("${e.itemSeqId.toString()}"),
                  ),
                  title: Text(
                      finDoc.docType == 'order' || finDoc.docType == 'invoice'
                          ? "ProductId: ${e.productId} "
                                  "Description: ${e.description} "
                                  "Quantity: ${e.quantity.toString()} "
                                  "Price: ${e.price.toString()} "
                                  "SubTotal: ${(e.quantity! * e.price!).toString()}" +
                              (e.rentalFromDate == null
                                  ? ''
                                  : " Rental: ${e.rentalFromDate.toString().substring(0, 10)} "
                                      "${e.rentalThruDate.toString().substring(0, 10)}")
                          : finDoc.docType == 'transaction'
                              ? "ProductId: ${e.productId} "
                                  "Description: ${e.description} "
                              : "ProductId: ${e.productId} " // shipment
                                  "Quantity: ${e.quantity.toString()} ",
                      key: Key('itemLine$index'))))
        ])));
  }
}
