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
// original article:
// https://www.kindacode.com/article/flutter-making-a-dropdown-multiselect-with-checkboxes/
import 'package:flutter/material.dart';

class MultiSelect<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final List<T> selectedItems;
  const MultiSelect(
      {Key? key,
      this.title = 'Please select one or more',
      required this.items,
      this.selectedItems = const []})
      : super(key: key);

  @override
  MultiSelectState createState() => MultiSelectState<T>();
}

class MultiSelectState<T> extends State<MultiSelect> {
// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        widget.selectedItems.add(itemValue);
      } else {
        widget.selectedItems.remove(itemValue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value: widget.selectedItems.contains(item),
                    title: Text(item.toString()),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: (() => Navigator.pop(context)),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: (() => Navigator.pop(context, widget.selectedItems)),
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
