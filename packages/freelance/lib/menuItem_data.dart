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
import 'package:core/domains/domains.dart';

const MENU_DASHBOARD = 0;
const MENU_COMPANY = 1;
const MENU_CRM = 2;
const MENU_CATALOG = 3;
const MENU_SALES = 4;
const MENU_PURCHASE = 5;
const MENU_ACCOUNTING = 6;
const MENU_ACCTSALES = 1;
const MENU_ACCTPURCHASE = 2;
const MENU_ACCTLEDGER = 3;

List<MenuItem> menuItems = [
  MenuItem(
    image: "assets/images/dashBoardGrey.png",
    selectedImage: "assets/images/dashBoard.png",
    title: "Main",
    route: '/',
    readGroups: ["GROWERP_M_ADMIN", "GROWERP_M_EMPLOYEE", "ADMIN"],
    writeGroups: ["GROWERP_M_ADMIN", "ADMIN"],
    child: local.FreelanceDbForm(),
  ),
  MenuItem(
      image: "assets/images/tasksGrey.png",
      selectedImage: "assets/images/tasks.png",
      title: "Tasks",
      route: '/tasks',
      readGroups: ["GROWERP_M_ADMIN", "GROWERP_M_EMPLOYEE", "ADMIN"],
      writeGroups: ["GROWERP_M_ADMIN", "GROWERP_M_EMPLOYEE", "ADMIN"],
      child: TaskListForm()),
  MenuItem(
    image: "assets/images/crmGrey.png",
    selectedImage: "assets/images/crm.png",
    title: "CRM",
    route: '/crm',
    readGroups: ["GROWERP_M_ADMIN", "GROWERP_M_EMPLOYEE", "ADMIN"],
    tabItems: [
      TabItem(
        form: OpportunityListForm(),
        label: "My Opportunities",
        icon: Icon(Icons.home),
      ),
      TabItem(
        form: UserListForm(
          key: Key("Lead"),
          userGroupId: "GROWERP_M_LEAD",
        ),
        label: "Leads",
        icon: Icon(Icons.business),
      ),
      TabItem(
        form: UserListForm(
          key: Key("Customer"),
          userGroupId: "GROWERP_M_CUSTOMER",
        ),
        label: "Customers",
        icon: Icon(Icons.school),
      ),
    ],
  ),
  MenuItem(
      image: "assets/images/productsGrey.png",
      selectedImage: "assets/images/products.png",
      title: "Catalog",
      route: '/catalog',
      readGroups: [
        "GROWERP_M_ADMIN",
        "ADMIN",
        "GROWERP_M_EMPLOYEE"
      ],
      writeGroups: [
        "GROWERP_M_ADMIN"
      ],
      tabItems: [
        TabItem(
          form: ProductListForm(),
          label: "Products",
          icon: Icon(Icons.home),
        ),
        TabItem(
          form: AssetListForm(),
          label: "Assets",
          icon: Icon(Icons.money),
        ),
        TabItem(
          form: CategoryListForm(),
          label: "Categories",
          icon: Icon(Icons.business),
        ),
      ]),
  MenuItem(
    image: "assets/images/orderGrey.png",
    selectedImage: "assets/images/order.png",
    title: "Sales",
    route: '/sales',
    readGroups: ["GROWERP_M_ADMIN", "GROWERP_M_EMPLOYEE", "ADMIN"],
    writeGroups: ["GROWERP_M_ADMIN"],
    tabItems: [
      TabItem(
        form: FinDocListForm(
            key: Key("SalesOrder"), sales: true, docType: FinDocType.Order),
        label: "Sales orders",
        icon: Icon(Icons.home),
      ),
      TabItem(
        form: UserListForm(
          key: Key("Customer"),
          userGroupId: "GROWERP_M_CUSTOMER",
        ),
        label: "Customers",
        icon: Icon(Icons.business),
      )
    ],
  ),
  MenuItem(
    image: "assets/images/supplierGrey.png",
    selectedImage: "assets/images/supplier.png",
    title: "Purchase",
    route: '/purchase',
    readGroups: ["GROWERP_M_ADMIN", "GROWERP_M_EMPLOYEE", "ADMIN"],
    tabItems: [
      TabItem(
        form: FinDocListForm(
            key: Key("PurchaseOrder"), sales: false, docType: FinDocType.Order),
        label: "Purchase orders",
        icon: Icon(Icons.home),
      ),
      TabItem(
        form: UserListForm(
          key: Key("Supplier"),
          userGroupId: "GROWERP_M_SUPPLIER",
        ),
        label: "Suppliers",
        icon: Icon(Icons.business),
      )
    ],
  ),
  MenuItem(
      image: "assets/images/accountingGrey.png",
      selectedImage: "assets/images/accounting.png",
      title: "Accounting",
      route: '/accounting',
      readGroups: ["GROWERP_M_ADMIN", "ADMIN"]),
  MenuItem(
      image: "packages/core/images/infoGrey.png",
      selectedImage: "packages/core/images/info.png",
      title: "About",
      route: '/about',
      readGroups: ["GROWERP_M_ADMIN", "ADMIN"]),
];
List<MenuItem> acctMenuItems = [
  MenuItem(
      image: "assets/images/accountingGrey.png",
      selectedImage: "assets/images/accounting.png",
      title: "     Acct\nDashBoard",
      route: '/accounting',
      readGroups: ["GROWERP_M_ADMIN", "GROWERP_M_EMPLOYEE", "ADMIN"]),
  MenuItem(
      image: "assets/images/orderGrey.png",
      selectedImage: "assets/images/order.png",
      title: " Acct\nSales",
      route: '/acctSales',
      readGroups: ["GROWERP_M_ADMIN", "ADMIN"]),
  MenuItem(
      image: "assets/images/supplierGrey.png",
      selectedImage: "assets/images/supplier.png",
      title: "    Acct\nPurchase",
      route: '/acctPurchase',
      readGroups: ["GROWERP_M_ADMIN", "ADMIN"],
      writeGroups: ["GROWERP_M_ADMIN"]),
  MenuItem(
      image: "assets/images/accountingGrey.png",
      selectedImage: "assets/images/accounting.png",
      title: "Ledger",
      route: '/ledger',
      readGroups: ["GROWERP_M_ADMIN", "ADMIN"],
      writeGroups: ["GROWERP_M_ADMIN"]),
  MenuItem(
      image: "assets/images/dashBoardGrey.png",
      selectedImage: "assets/images/dashBoard.png",
      title: "Main",
      route: '/',
      readGroups: ["GROWERP_M_ADMIN", "GROWERP_M_EMPLOYEE", "ADMIN"]),
];
