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
import 'forms/@forms.dart' as local;
import 'package:core/forms/@forms.dart';

// https://medium.com/flutter-community/flutter-navigation-cheatsheet-a-guide-to-named-routing-dc642702b98c
Route<dynamic> generateRoute(RouteSettings settings) {
  print(">>>NavigateTo { ${settings.name} " +
      "with: ${settings.arguments.toString()} }");
  switch (settings.name) {
    case '/home':
      return MaterialPageRoute(
          builder: (context) => local.HomeForm(settings.arguments));
    case '/catalog':
      return MaterialPageRoute(
          builder: (context) => local.CatalogForm(settings.arguments));
    case '/category':
      return MaterialPageRoute(
          builder: (context) => local.CategoryForm(settings.arguments));
    case '/employee':
      return MaterialPageRoute(
          builder: (context) => EmployeeForm(settings.arguments));
    case '/login':
      return MaterialPageRoute(
          builder: (context) => LoginForm(settings.arguments));
    case '/register':
      return MaterialPageRoute(
          builder: (context) => RegisterForm(settings.arguments));
    case '/changePw':
      return MaterialPageRoute(
          builder: (context) => ChangePwForm(changePwArgs: settings.arguments));
    case '/about':
      return MaterialPageRoute(builder: (context) => AboutForm());
    case '/company':
      return MaterialPageRoute(
          builder: (context) => CompanyForm(settings.arguments));
    case '/employees':
      return MaterialPageRoute(
          builder: (context) => local.EmployeesForm(settings.arguments));
    case '/product':
      return MaterialPageRoute(
          builder: (context) => local.ProductForm(settings.arguments));
    case '/orders':
      return MaterialPageRoute(
          builder: (context) => local.OrdersForm(settings.arguments));
    case '/order':
      return MaterialPageRoute(
          builder: (context) => local.OrderForm(settings.arguments));
    case '/crm':
      return MaterialPageRoute(
          builder: (context) => local.CrmForm(settings.arguments));
    case '/opportunity':
      return MaterialPageRoute(
          builder: (context) => local.OpportunityForm(settings.arguments));
    case '/crmUser':
      return MaterialPageRoute(
          builder: (context) => local.CrmUserForm(settings.arguments));
    default:
      return MaterialPageRoute(
          builder: (context) => FatalErrorForm(
              "Routing not found for request: ${settings.name}"));
  }
}
