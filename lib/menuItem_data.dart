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

import 'package:core/domains/domains.dart';
import 'package:models/@models.dart';
import 'package:flutter/material.dart';
import 'forms/@forms.dart' as local;
import 'package:core/forms/@forms.dart';

List<MenuItem> menuItems = [
  MenuItem(
    image: "assets/images/dashBoardGrey.png",
    selectedImage: "assets/images/dashBoard.png",
    title: "Main",
    route: '/',
    readGroups: ["GROWERP_M_ADMIN", "GROWERP_M_EMPLOYEE", "ADMIN"],
    writeGroups: ["GROWERP_M_ADMIN", "ADMIN"],
    child: local.AdminDbForm(),
  ),
  MenuItem(
    image: "assets/images/companyGrey.png",
    selectedImage: "assets/images/company.png",
    title: "Company",
    route: '/company',
    readGroups: ["GROWERP_M_ADMIN", "GROWERP_M_EMPLOYEE", "ADMIN"],
    writeGroups: ["GROWERP_M_ADMIN", "ADMIN"],
    tabItems: [
      TabItem(
        form: CompanyInfoForm(FormArguments()),
        label: "Company Info",
        icon: Icon(Icons.home),
      ),
      TabItem(
        form: UsersForm(
          key: Key("Admin"),
          userGroupId: "GROWERP_M_ADMIN",
        ),
        label: "Admins",
        icon: Icon(Icons.business),
        floatButtonForm: UserDialog(
            formArguments: FormArguments(
                object: User(
                    userGroupId: "GROWERP_M_ADMIN",
                    groupDescription: "Admin"))),
      ),
      TabItem(
        form: UsersForm(
          key: Key("Employee"),
          userGroupId: "GROWERP_M_EMPLOYEE",
        ),
        label: "Employees",
        icon: Icon(Icons.school),
        floatButtonForm: UserDialog(
            formArguments: FormArguments(
                object: User(
                    userGroupId: "GROWERP_M_EMPLOYEE",
                    groupDescription: "Employee"))),
      ),
    ],
  ),
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
    title: "Orders",
    route: '/orders',
    readGroups: ["GROWERP_M_ADMIN", "GROWERP_M_EMPLOYEE", "ADMIN"],
    writeGroups: ["GROWERP_M_ADMIN"],
    tabItems: [
      TabItem(
        form: FinDocListForm(
            key: Key("SalesOrder"), sales: true, docType: 'order'),
        label: "Sales orders",
        icon: Icon(Icons.home),
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
      TabItem(
        form: FinDocListForm(
            key: Key("PurchaseOrder"), sales: false, docType: 'order'),
        label: "Purchase orders",
        icon: Icon(Icons.home),
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
    image: "assets/images/supplierGrey.png",
    selectedImage: "assets/images/supplier.png",
    title: "Warehouse",
    route: '/warehouse',
    readGroups: ["GROWERP_M_ADMIN", "GROWERP_M_EMPLOYEE", "ADMIN"],
    tabItems: [
      TabItem(
        form: LocationListForm(),
        label: "WH Locations",
        icon: Icon(Icons.transform_outlined),
      ),
      TabItem(
        form: FinDocListForm(
            key: Key("ShipmentsOut"), sales: true, docType: 'shipment'),
        label: "Outgoing shipments",
        icon: Icon(Icons.transform_outlined),
      ),
      TabItem(
        form: FinDocListForm(
            key: Key("ShipmentsIn"), sales: false, docType: 'shipment'),
        label: "Incoming shipments",
        icon: Icon(Icons.transform_outlined),
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
