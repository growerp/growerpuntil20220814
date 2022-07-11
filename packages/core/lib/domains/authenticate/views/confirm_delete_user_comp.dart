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

import '../../domains.dart';

/// dialog returns true when company delete, false when not,
/// null when cancelled
///
confirmDeleteUserComp(BuildContext context, UserGroup userGroup) {
  // set up the buttons
  Widget cancelButton = ElevatedButton(
    child: Text("cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget alsoCompanyDeleteButton = ElevatedButton(
    child: Text("User AND Company delete"),
    onPressed: () {
      Navigator.of(context).pop(true);
    },
  );
  Widget justUserDeleteButton = ElevatedButton(
    child: Text("Only User delete"),
    onPressed: () {
      Navigator.of(context).pop(false);
    },
  );

  List<Widget> actions = [cancelButton, justUserDeleteButton];
  if (userGroup == UserGroup.Admin) actions.add(alsoCompanyDeleteButton);

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0))),
    title: Text(
        "Delete user ${userGroup == UserGroup.Admin ? ' and optionally company?' : ''}"),
    content: Text("Please note this cannot be undone!"),
    actions: actions,
  );

  // show the dialog
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
