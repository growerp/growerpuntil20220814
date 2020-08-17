import 'package:flutter/material.dart';

class Themes {
  Themes._();

  static ThemeData formTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: Color(0xFF4baa9b)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: Color(0xFFce5310)),
      ),
    ),
    errorColor: Colors.red,
    cardColor: Colors.black,
    canvasColor: Colors.white, // modal popup background
    scaffoldBackgroundColor: Colors.white,
//    iconTheme: IconThemeData(color: Colors.black),
    appBarTheme: AppBarTheme(
      color: Color(0xFF4baa9b),
      elevation: 0,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFF4baa9b),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
    hintColor: Color(0xFF4baa9b),
    disabledColor: Color(0x80FFFFFF),
    accentColor: Color(0xFFce5310),
    dividerColor: Colors.white30,
    toggleableActiveColor: Color(0xFFce5310),
    unselectedWidgetColor: Colors.black,
  );
}
