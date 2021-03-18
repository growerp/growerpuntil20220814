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

class ReportsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      menu: acctMenuItems,
      mapItems: reportsMap,
      menuIndex: MENU_ACCTLEDGER,
    );
  }
}

List<MapItem> reportsMap = [
  MapItem(
    form: BalanceSheetForm(),
    label: "Balance Sheet",
    icon: Icon(Icons.home),
    floatButtonRoute: "/balanceSheet",
  ),
  MapItem(
    form: IncomeStatementForm(),
    label: "Income Statement",
    icon: Icon(Icons.business),
    floatButtonRoute: "/incomeStatement",
    floatButtonArgs: FormArguments(),
  ),
];
