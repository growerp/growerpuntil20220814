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
import 'package:core/domains/domains.dart';

import '../menuItem_data.dart';

class FreelanceDbForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state.status == AuthStatus.authenticated) {
        Authenticate authenticate = state.authenticate!;
        return DashBoardForm(dashboardItems: [
          makeDashboardItem(
            'dbCompany',
            context,
            menuOptions[1],
            authenticate.company!.name!.length > 20
                ? "${authenticate.company!.name!.substring(0, 20)}..."
                : "${authenticate.company!.name}",
            "All open tasks: ${authenticate.stats!.allTasks}",
            "Not Invoiced hours: ${authenticate.stats!.notInvoicedHours}",
            "",
          ),
          makeDashboardItem(
            'dbCrm',
            context,
            menuOptions[2],
            "All Opportunities: ${authenticate.stats!.opportunities}",
            "My Opportunities: ${authenticate.stats!.myOpportunities}",
            "Leads: ${authenticate.stats!.leads}",
            "Customers: ${authenticate.stats!.customers}",
          ),
          makeDashboardItem(
            'dbCatalog',
            context,
            menuOptions[3],
            "Categories: ${authenticate.stats!.categories}",
            "Products: ${authenticate.stats!.products}",
            "Assets: ${authenticate.stats!.products}",
            "",
          ),
          makeDashboardItem(
            'dbSales',
            context,
            menuOptions[4],
            "Orders: ${authenticate.stats!.openSlsOrders}",
            "Customers: ${authenticate.stats!.customers}",
            "",
            "",
          ),
          makeDashboardItem(
            'dbAccounting',
            context,
            menuOptions[6],
            "Sales open invoices: \n"
                "${authenticate.company!.currency!.currencyId} "
                "${authenticate.stats!.salesInvoicesNotPaidAmount ?? '0.00'} "
                "(${authenticate.stats!.salesInvoicesNotPaidCount})",
            "Purchase unpaid invoices: \n"
                "${authenticate.company!.currency!.currencyId} "
                "${authenticate.stats!.purchInvoicesNotPaidAmount ?? '0.00'} "
                "(${authenticate.stats!.purchInvoicesNotPaidCount})",
            "",
            "",
          ),
          makeDashboardItem(
            'dbPurchase',
            context,
            menuOptions[5],
            "Orders: ${authenticate.stats!.openPurOrders}",
            "Suppliers: ${authenticate.stats!.suppliers}",
            "",
            "",
          ),
        ]);
      }
      return LoadingIndicator();
    });
  }
}
