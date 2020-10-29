import 'package:flutter/material.dart';

class HelperFunctions {
  static void showMessage(context, message, colors) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Text('$message')),
            ],
          ),
          backgroundColor: colors,
        ),
      );
  }
}
