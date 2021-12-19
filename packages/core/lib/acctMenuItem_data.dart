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
import 'package:core/domains/domains.dart';

const MENU_ACCOUNTING = 6;
const MENU_ACCTSALES = 1;
const MENU_ACCTPURCHASE = 2;
const MENU_ACCTLEDGER = 3;

List<MenuItem> acctMenuItems = [
  MenuItem(
    image: "assets/images/accountingGrey.png",
    selectedImage: "assets/images/accounting.png",
    title: "     Acct\nDashBoard",
    route: '/accounting',
    readGroups: [UserGroup.Admin, UserGroup.Employee, UserGroup.SuperAdmin],
    child: AcctDashBoard(),
  ),
  MenuItem(
      image: "assets/images/orderGrey.png",
      selectedImage: "assets/images/order.png",
      title: " Acct\nSales",
      route: '/acctSales',
      readGroups: [
        UserGroup.Admin,
        UserGroup.SuperAdmin
      ],
      tabItems: [
        TabItem(
          form: FinDocListForm(
              key: Key("SalesInvoice"),
              sales: true,
              docType: FinDocType.Invoice),
          label: "Sales invoices",
          icon: Icon(Icons.home),
        ),
        TabItem(
          form: FinDocListForm(
              key: Key("SalesPayment"),
              sales: true,
              docType: FinDocType.Payment),
          label: "Sales payments(Receipts)",
          icon: Icon(Icons.home),
        ),
      ]),
  MenuItem(
      image: "assets/images/supplierGrey.png",
      selectedImage: "assets/images/supplier.png",
      title: "    Acct\nPurchase",
      route: '/acctPurchase',
      readGroups: [
        UserGroup.Admin,
        UserGroup.SuperAdmin
      ],
      writeGroups: [
        UserGroup.Admin
      ],
      tabItems: [
        TabItem(
          form: FinDocListForm(
              key: Key("PurchaseInvoice"),
              sales: false,
              docType: FinDocType.Invoice),
          label: "Purchase invoices",
          icon: Icon(Icons.home),
        ),
        TabItem(
          form: FinDocListForm(
              key: Key("PurchasePayment"),
              sales: false,
              docType: FinDocType.Payment),
          label: "Purchase payments",
          icon: Icon(Icons.home),
        ),
      ]),
  MenuItem(
      image: "assets/images/accountingGrey.png",
      selectedImage: "assets/images/accounting.png",
      title: "Ledger",
      route: '/ledger',
      readGroups: [
        UserGroup.Admin,
        UserGroup.SuperAdmin
      ],
      writeGroups: [
        UserGroup.Admin
      ],
      tabItems: [
        TabItem(
          form: LedgerTreeForm(),
          label: "Ledger Tree",
          icon: Icon(Icons.home),
        ),
        TabItem(
          form: FinDocListForm(
              key: Key("Transaction"),
              sales: true,
              docType: FinDocType.Transaction),
          label: "Transactions",
          icon: Icon(Icons.home),
        ),
      ]),
/*  MenuItem(
      image: "assets/images/accountingGrey.png",
      selectedImage: "assets/images/accounting.png",
      title: "Reports",
      route: '/reports',
      readGroups: [UserGroup.Admin, UserGroup.SuperAdmin],
      writeGroups: [UserGroup.Admin]),
*/
  MenuItem(
      image: "assets/images/dashBoardGrey.png",
      selectedImage: "assets/images/dashBoard.png",
      title: "Main",
      route: '/',
      readGroups: [UserGroup.Admin, UserGroup.Employee, UserGroup.SuperAdmin]),
];
