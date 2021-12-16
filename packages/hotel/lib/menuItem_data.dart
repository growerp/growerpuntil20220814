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

List<MenuItem> menuItems = [
  MenuItem(
    image: "assets/images/dashBoardGrey.png",
    selectedImage: "assets/images/dashBoard.png",
    title: "Main",
    route: '/',
    readGroups: ["GROWERP_M_ADMIN", "GROWERP_M_EMPLOYEE"],
    writeGroups: ["GROWERP_M_ADMIN"],
    child: GanttForm(),
    floatButtonForm: ReservationDialog(finDoc: FinDoc(items: [])),
  ),
  MenuItem(
    image: "assets/images/companyGrey.png",
    selectedImage: "assets/images/company.png",
    title: "Hotel",
    route: '/company',
    readGroups: ["GROWERP_M_ADMIN", "GROWERP_M_EMPLOYEE"],
    writeGroups: ["GROWERP_M_ADMIN"],
    tabItems: [
      TabItem(
        form: CompanyInfoForm(FormArguments()),
        label: "Company Info",
        icon: Icon(Icons.home),
      ),
      TabItem(
        form: UserListForm(
          key: Key("Admin"),
          userGroupId: "GROWERP_M_ADMIN",
        ),
        label: "Admins",
        icon: Icon(Icons.business),
      ),
      TabItem(
        form: UserListForm(
          key: Key("Employee"),
          userGroupId: "GROWERP_M_EMPLOYEE",
        ),
        label: "Employees",
        icon: Icon(Icons.school),
      ),
    ],
  ),
  MenuItem(
    image: "assets/images/single-bedGrey.png",
    selectedImage: "assets/images/single-bed.png",
    title: "Rooms",
    route: '/catalog',
    readGroups: ["GROWERP_M_ADMIN", "GROWERP_M_EMPLOYEE"],
    tabItems: [
      TabItem(
        form: AssetListForm(),
        label: "Rooms",
        icon: Icon(Icons.home),
        floatButtonForm: AssetDialog(Asset()),
      ),
      TabItem(
        form: ProductListForm(),
        label: "Room Types",
        icon: Icon(Icons.home),
      ),
    ],
  ),
  MenuItem(
      image: "assets/images/reservationGrey.png",
      selectedImage: "assets/images/reservation.png",
      title: "Reservations",
      route: '/sales',
      readGroups: [
        "GROWERP_M_ADMIN",
        "GROWERP_M_EMPLOYEE"
      ],
      writeGroups: [
        "GROWERP_M_ADMIN"
      ],
      tabItems: [
        TabItem(
          form: FinDocListForm(
              key: Key("SalesOrder"),
              sales: true,
              docType: 'order',
              onlyRental: true),
          label: "Reservations",
          icon: Icon(Icons.home),
          floatButtonForm: ReservationDialog(
            finDoc: FinDoc(sales: true, docType: 'order', items: []),
          ),
        ),
        TabItem(
          form: UserListForm(
            key: Key("Customer"),
            userGroupId: "GROWERP_M_CUSTOMER",
          ),
          label: "Customers",
          icon: Icon(Icons.business),
        ),
      ]),
  MenuItem(
      image: "assets/images/check-in-outGrey.png",
      selectedImage: "assets/images/check-in-out.png",
      title: "check-In-Out",
      route: '/checkInOut',
      readGroups: [
        "GROWERP_M_ADMIN",
        "GROWERP_M_EMPLOYEE"
      ],
      writeGroups: [
        "GROWERP_M_ADMIN"
      ],
      tabItems: [
        TabItem(
          form: FinDocListForm(
              key: Key("Check-In"),
              sales: true,
              docType: 'order',
              onlyRental: true,
              statusId: 'FinDocCreated'),
          label: "CheckIn",
          icon: Icon(Icons.home),
        ),
        TabItem(
          form: FinDocListForm(
              key: Key("Check-Out"),
              sales: true,
              docType: 'order',
              onlyRental: true,
              statusId: 'FinDocApproved'),
          label: "CheckOut",
          icon: Icon(Icons.home),
        ),
      ]),
  MenuItem(
      image: "assets/images/accountingGrey.png",
      selectedImage: "assets/images/accounting.png",
      title: "Accounting",
      route: '/accounting',
      readGroups: ["GROWERP_M_ADMIN"]),
];
