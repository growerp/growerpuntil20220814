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
import 'package:models/@models.dart';
import 'forms/@forms.dart' as local;
import 'package:core/domains/tasks/tasks.dart';
import 'package:core/domains/opportunities/opportunities.dart';
import 'package:core/domains/common/common.dart';
import 'package:core/forms/@forms.dart';

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
        form: UsersForm(
          key: Key("Lead"),
          userGroupId: "GROWERP_M_LEAD",
        ),
        label: "Leads",
        icon: Icon(Icons.business),
        floatButtonForm: UserDialog(
            formArguments: FormArguments(
                object: User(
                    userGroupId: "GROWERP_M_LEAD", groupDescription: "Lead"))),
      ),
      TabItem(
        form: UsersForm(
          key: Key("Customer"),
          userGroupId: "GROWERP_M_CUSTOMER",
        ),
        label: "Customers",
        icon: Icon(Icons.school),
        floatButtonForm: UserDialog(
            formArguments: FormArguments(
                object: User(
                    userGroupId: "GROWERP_M_CUSTOMER",
                    groupDescription: "Customer"))),
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
          form: ProductsForm(),
          label: "Products",
          icon: Icon(Icons.home),
          floatButtonForm:
              ProductDialog(formArguments: FormArguments(object: Product())),
        ),
        TabItem(
          form: AssetsForm(),
          label: "Assets",
          icon: Icon(Icons.money),
          floatButtonForm: AssetDialog(formArguments: FormArguments()),
        ),
        TabItem(
          form: CategoriesForm(),
          label: "Categories",
          icon: Icon(Icons.business),
          floatButtonForm: CategoryDialog(
              formArguments: FormArguments(object: ProductCategory())),
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
        form:
            FinDocsForm(key: Key("SalesOrder"), sales: true, docType: 'order'),
        label: "Sales orders",
        icon: Icon(Icons.home),
        floatButtonForm: FinDocDialog(
          formArguments: FormArguments(
              object: FinDoc(sales: true, docType: 'order', items: [])),
        ),
      ),
      TabItem(
        form: UsersForm(
          key: Key("Customer"),
          userGroupId: "GROWERP_M_CUSTOMER",
        ),
        label: "Customers",
        icon: Icon(Icons.business),
        floatButtonForm: UserDialog(
            formArguments: FormArguments(
                object: User(
                    userGroupId: "GROWERP_M_CUSTOMER",
                    groupDescription: "Customer"))),
      ),
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
        form: FinDocsForm(
            key: Key("PurchaseOrder"), sales: false, docType: 'order'),
        label: "Purchase orders",
        icon: Icon(Icons.home),
        floatButtonForm: FinDocDialog(
          formArguments: FormArguments(
              object: FinDoc(sales: false, docType: 'order', items: [])),
        ),
      ),
      TabItem(
        form: UsersForm(
          key: Key("Supplier"),
          userGroupId: "GROWERP_M_SUPPLIER",
        ),
        label: "Suppliers",
        icon: Icon(Icons.business),
        floatButtonForm: UserDialog(
            formArguments: FormArguments(
                object: User(
                    userGroupId: "GROWERP_M_SUPPLIER",
                    groupDescription: "Supplier"))),
      ),
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
