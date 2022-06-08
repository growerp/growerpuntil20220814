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

import 'package:collection/src/iterable_extensions.dart';
import 'package:core/services/api_result.dart';
import 'package:core/domains/domains.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../api_repository.dart';

class ShipmentReceiveDialog extends StatefulWidget {
  final FinDoc finDoc;
  ShipmentReceiveDialog(this.finDoc);
  @override
  _ShipmentReceiveState createState() => _ShipmentReceiveState(finDoc);
}

class _ShipmentReceiveState extends State<ShipmentReceiveDialog> {
  final FinDoc finDoc; // incoming finDoc
  late APIRepository repos;

  late bool isPhone;
  List<TextEditingController> _locationSearchBoxControllers = [];
  List<TextEditingController> _newLocationControllers = [];
  List<Location> _selectedLocations = [];
  List<FinDocItem> newItems = [];
  _ShipmentReceiveState(this.finDoc);
  late bool confirm;

  @override
  void initState() {
    super.initState();
    repos = context.read<APIRepository>();
    finDoc.items.forEach((_) {
      _locationSearchBoxControllers.add(TextEditingController());
      _newLocationControllers.add(TextEditingController());
      _selectedLocations.add(Location(locationName: 'Select'));
    });
    newItems = List.of(finDoc.items);
    confirm = false;
  }

  @override
  Widget build(BuildContext context) {
    isPhone = ResponsiveWrapper.of(context).isSmallerThan(TABLET);
    return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
                onTap: () {},
                child: Dialog(
                    key: Key(
                        "ShipmentReceiveDialog${finDoc.sales ? 'Sales' : 'Purchase'}"),
                    insetPadding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(clipBehavior: Clip.none, children: [
                      Container(
                          width: isPhone ? 400 : 800,
                          height: isPhone
                              ? 600
                              : 600, // not increase height otherwise tests will fail
                          child: shipmentItemList()),
                      Positioned(top: 5, right: 5, child: DialogCloseButton())
                    ])))));
  }

  Widget shipmentItemList() {
    FinDocBloc finDocBloc = context.read<FinDocBloc>();
    String nowDate = DateTime.now().toString().substring(0, 10);
    return Column(children: [
      Expanded(
          child: ListView.builder(
              key: Key('listView'),
              itemCount: newItems.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(children: [
                    ListTile(
                      leading: !isPhone
                          ? CircleAvatar(
                              backgroundColor: Colors.transparent,
                            )
                          : null,
                      title: Column(children: [
                        SizedBox(height: 20),
                        Center(
                            child: Text(
                                'Incoming Shipment# ${finDoc.shipmentId}',
                                style: TextStyle(
                                    fontSize: isPhone ? 10 : 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold))),
                        SizedBox(height: 20),
                        Center(
                            child: Text(
                                'For every Item either:\n'
                                '- Select an existing location\n'
                                '- Enter a new location\n'
                                '- leave empty for a new location with\n'
                                '   the name of the item and received date',
                                style: TextStyle(
                                    fontSize: isPhone ? 20 : 30,
                                    color: Colors.black))),
                        SizedBox(height: 30),
                        Row(children: <Widget>[
                          Text('ProductId  '),
                          Expanded(child: Text('Description')),
                          Text('quantity'),
                        ]),
                      ]),
                      subtitle: Row(children: <Widget>[
                        Expanded(
                            child: Text('existing location',
                                textAlign: TextAlign.center)),
                        Expanded(
                            child: Text('new location',
                                textAlign: TextAlign.center)),
                      ]),
                    ),
                    Divider(color: Colors.black),
                  ]);
                }
                if (index == 1 && newItems.isEmpty)
                  return Center(
                      heightFactor: 20,
                      child: Text("no items found!",
                          key: Key('empty'), textAlign: TextAlign.center));
                index--;
                return ListTile(
                  leading: !isPhone
                      ? CircleAvatar(
                          backgroundColor: Colors.transparent,
                        )
                      : null,
                  title: Column(children: [
                    Row(children: <Widget>[
                      Text('${newItems[index].productId}'),
                      SizedBox(width: 10),
                      Expanded(child: Text('${newItems[index].description}')),
                      Text('${newItems[index].quantity}'),
                    ]),
                    SizedBox(height: 10),
                    confirm
                        ? Text(
                            'To location: ${newItems[index].location?.locationName}')
                        : Row(children: <Widget>[
                            Expanded(
                                child: SizedBox(
                                    height: 60,
                                    child: DropdownSearch<Location>(
                                      key: Key('locationDropDown'),
                                      selectedItem: _selectedLocations[index],
                                      popupProps: PopupProps.menu(
                                        showSearchBox: true,
                                        searchFieldProps: TextFieldProps(
                                          autofocus: true,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        25.0)),
                                          ),
                                          controller:
                                              _locationSearchBoxControllers[
                                                  index],
                                        ),
                                        menuProps: MenuProps(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        title: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
                                                )),
                                            child: Center(
                                                child: Text('Select location',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    )))),
                                      ),
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: 'Location',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0)),
                                      ),
                                      showClearButton: false,
                                      itemAsString: (Location? u) =>
                                          "${u?.locationName}",
                                      asyncItems: (String? filter) async {
                                        ApiResult<List<Location>> result =
                                            await repos.getLocation(
                                                filter:
                                                    _locationSearchBoxControllers[
                                                            index]
                                                        .text);
                                        return result.when(
                                            success: (data) => data,
                                            failure: (_) => [
                                                  Location(
                                                      locationName:
                                                          'get data error')
                                                ]);
                                      },
                                      validator: (value) {
                                        return value == null
                                            ? "Select a location?"
                                            : null;
                                      },
                                      onChanged: (Location? newValue) {
                                        setState(() {
                                          _selectedLocations[index] = newValue!;
                                          _newLocationControllers[index].text =
                                              '';
                                        });
                                      },
                                    ))),
                            SizedBox(width: 10),
                            Expanded(
                                child: TextFormField(
                              key: Key('newLocation$index'),
                              decoration:
                                  InputDecoration(labelText: 'New Location'),
                              controller: _newLocationControllers[index],
                              onChanged: (_) {
                                setState(() {
                                  _selectedLocations[index] =
                                      Location(locationName: '');
                                });
                              },
                            ))
                          ])
                  ]),
                );
              })),
      SizedBox(
          height: 50,
          child: Row(children: [
            Visibility(
                visible: confirm,
                child: ElevatedButton(
                    key: Key('back'),
                    child: Text('Go back'),
                    onPressed: () async {
                      setState(() {
                        confirm = false;
                      });
                      newItems.forEachIndexed((index, value) {
                        newItems[index] = value.copyWith(
                            location: _selectedLocations[index].locationId !=
                                    null
                                ? _selectedLocations[index]
                                : Location(
                                    locationName:
                                        _newLocationControllers[index].text));
                      });
                      finDocBloc.add(FinDocShipmentReceive(
                          finDoc.copyWith(items: newItems)));
                    })),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: ElevatedButton(
                    key: Key('update'),
                    child: Text(confirm ? 'Confirm ' : '' + 'Receive shipment'),
                    onPressed: () async {
                      setState(() {
                        if (confirm == false) {
                          newItems.forEachIndexed((index, value) {
                            newItems[index] = value.copyWith(
                                location: _selectedLocations[index]
                                            .locationId !=
                                        null
                                    ? _selectedLocations[index]
                                    : _newLocationControllers[index]
                                            .text
                                            .isNotEmpty
                                        ? Location(
                                            locationName:
                                                _newLocationControllers[index]
                                                    .text)
                                        : Location(
                                            locationName:
                                                '${newItems[index].description}'
                                                '($nowDate)'));
                            confirm = true;
                          });
                        } else {
                          finDocBloc.add(FinDocShipmentReceive(
                              finDoc.copyWith(items: newItems)));
                          Navigator.of(context).pop();
                        }
                      });
                    }))
          ])),
      SizedBox(height: 20)
    ]);
  }
}
