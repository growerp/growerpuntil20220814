import 'package:flutter/material.dart';
import 'routing_constants.dart';
import 'forms/@forms.dart';

// https://medium.com/flutter-community/flutter-navigation-cheatsheet-a-guide-to-named-routing-dc642702b98c
Route<dynamic> generateRoute(RouteSettings settings) {
  print("NavigateTo { ${settings.name} " +
      "with data: ${settings.arguments.toString()} }");
  switch (settings.name) {
    case HomeRoute:
      return MaterialPageRoute(
          builder: (context) => AdminHome(settings.arguments));
    case UserRoute:
      return MaterialPageRoute(
          builder: (context) => UserForm(settings.arguments));
    case LoginRoute:
      return MaterialPageRoute(
          builder: (context) => LoginForm(settings.arguments));
    case RegisterRoute:
      return MaterialPageRoute(
          builder: (context) => RegisterForm(settings.arguments));
    case ChangePwRoute:
      return MaterialPageRoute(
          builder: (context) => ChangePwForm(changePwArgs: settings.arguments));
    case AboutRoute:
      return MaterialPageRoute(builder: (context) => AboutForm());
    case CompanyRoute:
      return MaterialPageRoute(
          builder: (context) => CompanyForm(settings.arguments));
    case UsersRoute:
      return MaterialPageRoute(
          builder: (context) => UsersForm(settings.arguments));
    default:
      return MaterialPageRoute(
          builder: (context) => UndefinedView(name: settings.name));
  }
}
