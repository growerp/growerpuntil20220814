/*
 * This software is in the public domain under CC0 1.0 Universal plus a
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
import 'package:core/templates/@templates.dart';
import 'package:models/@models.dart';
import '@forms.dart';

class AccntSalesForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      menu: acctMenuItems,
      mapItems: acctSalesMap,
      menuIndex: MENU_ACCTSALES,
      tabIndex: 0,
    );
  }
}

List<MapItem> acctSalesMap = [
  MapItem(
    form: FinDocsForm(sales: true, docType: 'invoice'),
    label: "Sales invoices",
    icon: Icon(Icons.home),
    floatButtonRoute: "/invoice",
    floatButtonArgs: FormArguments(
        object: FinDoc(sales: true, docType: 'invoice', items: []),
        menuIndex: MENU_ACCTSALES),
  ),
  MapItem(
    form: FinDocsForm(sales: true, docType: 'payment'),
    label: "Sales payments(Receipts)",
    icon: Icon(Icons.home),
    floatButtonRoute: "/payment",
    floatButtonArgs: FormArguments(
        object: FinDoc(sales: true, docType: 'payment', items: []),
        menuIndex: MENU_ACCTSALES),
  ),
];
