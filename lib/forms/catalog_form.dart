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
import 'package:models/@models.dart';
import 'package:core/templates/@templates.dart';
import '@forms.dart';

class CatalogForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      menu: menuItems,
      mapItems: catalogMap,
      menuIndex: MENU_CATALOG,
      title: "Catalog",
    );
  }
}

List<MapItem> catalogMap = [
  MapItem(
      form: ProductsForm(),
      label: "Products",
      icon: Icon(Icons.home),
      floatButtonRoute: "/product",
      floatButtonArgs: FormArguments()),
  MapItem(
      form: CategoriesForm(),
      label: "Categories",
      icon: Icon(Icons.business),
      floatButtonRoute: "/category",
      floatButtonArgs: FormArguments()),
];
