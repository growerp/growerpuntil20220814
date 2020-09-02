import 'package:flutter/material.dart';

/// dialog returns true when continue, false when cancelled
confirmDialog(BuildContext context, String title, String content) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop(false);
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Continue"),
    onPressed: () {
      Navigator.of(context).pop(true);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("$title"),
    content: Text("$content"),
    actions: [
      cancelButton,
      continueButton,
    ],
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
