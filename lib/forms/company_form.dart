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

import 'package:core/forms/@forms.dart';
import 'package:flutter/material.dart';
import 'package:core/templates/@templates.dart';
import 'package:models/@models.dart';
import '@forms.dart';

class CompanyForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      mapItems: companyMap,
      menuIndex: 1,
    );
  }
}

List<MapItem> companyMap = [
  MapItem(
    form: CompanyInfoForm(FormArguments()),
    label: "Company Info",
    icon: Icon(Icons.home),
  ),
  MapItem(
    form: UsersForm(
        key: ValueKey("GROWERP_M_ADMIN"),
        userGroupId: "GROWERP_M_ADMIN",
        menuIndex: MENU_COMPANY),
    label: "Admins",
    icon: Icon(Icons.business),
    floatButtonRoute: "/user",
    floatButtonArgs: User(userGroupId: "GROWERP_M_ADMIN"),
  ),
  MapItem(
    form: UsersForm(
        key: ValueKey("GROWERP_M_EMPLOYEE"),
        userGroupId: "GROWERP_M_EMPLOYEE",
        menuIndex: MENU_COMPANY),
    label: "Employees",
    icon: Icon(Icons.school),
    floatButtonRoute: "/user",
    floatButtonArgs: User(userGroupId: "GROWERP_M_EMPLOYEE"),
  ),
];
