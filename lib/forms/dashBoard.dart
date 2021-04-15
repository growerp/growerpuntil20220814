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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/blocs/@blocs.dart';
import 'package:models/@models.dart';
import 'package:core/widgets/@widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../menuItem_data.dart';

class DashBoardForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) {
        Authenticate authenticate = state.authenticate!;
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: GridView.count(
            crossAxisCount:
                ResponsiveWrapper.of(context).isSmallerThan(TABLET) ? 2 : 3,
            padding: EdgeInsets.all(3.0),
            children: <Widget>[
              makeDashboardItem(
                context,
                menuItems[1],
                authenticate.company!.name!.length > 20
                    ? "${authenticate.company!.name!.substring(0, 20)}..."
                    : "${authenticate.company!.name}",
                "Administrators: ${authenticate.stats!.admins}",
                "Employees: ${authenticate.stats!.employees}",
                "",
              ),
              makeDashboardItem(
                context,
                menuItems[2],
                "All Opportunities: ${authenticate.stats!.opportunities}",
                "My Opportunities: ${authenticate.stats!.myOpportunities}",
                "Leads: ${authenticate.stats!.leads}",
                "Customers: ${authenticate.stats!.customers}",
              ),
              makeDashboardItem(
                context,
                menuItems[3],
                "Categories: ${authenticate.stats!.categories}",
                "Products: ${authenticate.stats!.products}",
                "",
                "",
              ),
              makeDashboardItem(
                context,
                menuItems[4],
                "Orders: ${authenticate.stats!.openSlsOrders}",
                "Customers: ${authenticate.stats!.customers}",
                "",
                "",
              ),
              makeDashboardItem(
                context,
                menuItems[6],
                "Sls open inv: "
                    "${authenticate.company!.currencyId} "
                    "${authenticate.stats!.salesInvoicesNotPaidAmount}"
                    "(${authenticate.stats!.salesInvoicesNotPaidCount})",
                "Pur unp inv: "
                    "${authenticate.company!.currencyId} "
                    "${authenticate.stats!.purchInvoicesNotPaidAmount}"
                    "(${authenticate.stats!.purchInvoicesNotPaidCount})",
                "",
                "",
              ),
              makeDashboardItem(
                context,
                menuItems[5],
                "Orders: ${authenticate.stats!.openPurOrders}",
                "Suppliers: ${authenticate.stats!.suppliers}",
                "",
                "",
              ),
            ],
          ),
        );
      }

      return LoadingIndicator();
    });
  }
}
