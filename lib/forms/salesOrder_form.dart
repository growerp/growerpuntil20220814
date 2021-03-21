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

class SalesOrderForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      menu: menuItems,
      mapItems: salesMap,
      menuIndex: MENU_SALES,
      tabIndex: 0,
    );
  }
}

List<MapItem> salesMap = [
  MapItem(
    form: FinDocsForm(sales: true, docType: 'order'),
    label: "Sales orders",
    icon: Icon(Icons.home),
    floatButtonRoute: "/order",
    floatButtonArgs: FormArguments(
        object: FinDoc(sales: true, docType: 'order', items: []),
        menuIndex: MENU_SALES),
  ),
  MapItem(
      form: UsersForm(
          key: ValueKey("GROWERP_M_CUSTOMER"),
          userGroupId: "GROWERP_M_CUSTOMER",
          menuIndex: MENU_SALES),
      label: "Customers",
      icon: Icon(Icons.business),
      floatButtonRoute: "/user",
      floatButtonArgs: FormArguments(
          object: User(userGroupId: "GROWERP_M_CUSTOMER"),
          menuIndex: MENU_SALES)),
];
