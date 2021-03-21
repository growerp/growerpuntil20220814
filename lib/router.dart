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
    case '/':
      return MaterialPageRoute(builder: (context) => local.HomeForm());
    case '/home':
      return MaterialPageRoute(builder: (context) => local.HomeForm());
    case '/accounting':
      return MaterialPageRoute(builder: (context) => local.AccountingForm());
    case '/catalog':
      return MaterialPageRoute(builder: (context) => local.CatalogForm());
    case '/category':
      return MaterialPageRoute(
          builder: (context) =>
              local.CategoryForm(formArguments: settings.arguments));
    case '/company':
      return MaterialPageRoute(builder: (context) => local.CompanyForm());
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
    case '/product':
      return MaterialPageRoute(
          builder: (context) =>
              local.ProductForm(formArguments: settings.arguments));
    case '/sales':
      return MaterialPageRoute(builder: (context) => local.SalesOrderForm());
    case '/purchase':
      return MaterialPageRoute(builder: (context) => local.PurchaseOrderForm());
    case '/acctSales':
      return MaterialPageRoute(
          builder: (context) => local.AccntSalesOrderForm());
    case '/acctPurchase':
      return MaterialPageRoute(
          builder: (context) => local.AccntPurchaseOrderForm());
    case '/ledger':
      return MaterialPageRoute(builder: (context) => local.LedgerForm());
    case '/ledgerTree':
      return MaterialPageRoute(builder: (context) => local.LedgerTreeForm());
    case '/balanceSheet':
      return MaterialPageRoute(builder: (context) => local.BalanceSheetForm());
    case '/reports':
      return MaterialPageRoute(builder: (context) => local.ReportsForm());
    case '/order':
      return MaterialPageRoute(
          builder: (context) =>
              local.FinDocForm(formArguments: settings.arguments));
    case '/crm':
      return MaterialPageRoute(builder: (context) => local.CrmForm());
    case '/opportunity':
      return MaterialPageRoute(
          builder: (context) =>
              local.OpportunityForm(opportunity: settings.arguments));
    case '/user':
      return MaterialPageRoute(
          builder: (context) =>
              local.UserForm(formArguments: settings.arguments));
    default:
      return MaterialPageRoute(
          builder: (context) => FatalErrorForm(
              "Routing not found for request: ${settings.name}"));
  }
}
