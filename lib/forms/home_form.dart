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
import 'package:models/models.dart';
import 'package:core/helper_functions.dart';
import 'package:core/widgets/@widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomeForm extends StatelessWidget {
  final FormArguments formArguments;
  HomeForm(this.formArguments);

  @override
  Widget build(BuildContext context) {
    var a = (formArguments) => (DashBoard(formArguments?.message));
    return ShowNavigationRail(a(formArguments), 0);
  }
}

class DashBoard extends StatelessWidget {
  final String message;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  DashBoard([this.message]) {
    HelperFunctions.showTopMessage(scaffoldMessengerKey, message);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthProblem) {
        return Container(
            child: Center(
                child: Text("${state.errorMessage}",
                    style:
                        new TextStyle(fontSize: 18.0, color: Colors.black))));
      }
      if (state is AuthAuthenticated) {
        Authenticate authenticate = state.authenticate;
        List<ProductCategory> categories;
        List<Product> products;
        Crm crm;
        BalanceSheet balanceSheet;
        List<Order> orders;
        return BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
          if (state is ProductSuccess) products = state.products;
          return BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
            if (state is CategorySuccess) categories = state.categories;
            return BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
              if (state is OrderLoaded) orders = state.orders;
              return BlocBuilder<CrmBloc, CrmState>(builder: (context, state) {
                if (state is CrmLoaded) crm = state.crm;
                return BlocBuilder<AccntgBloc, AccntgState>(
                    builder: (context, state) {
                  if (state is AccntgLoaded) balanceSheet = state.balanceSheet;
                  return ScaffoldMessenger(
                      key: scaffoldMessengerKey,
                      child: Scaffold(
                          appBar: AppBar(
                              automaticallyImplyLeading:
                                  ResponsiveWrapper.of(context)
                                      .isSmallerThan(TABLET),
                              title: companyLogo(context, authenticate,
                                  authenticate?.company?.name ?? 'Company??'),
                              actions: <Widget>[
                                if (authenticate?.apiKey != null)
                                  IconButton(
                                      icon: Icon(Icons.do_not_disturb),
                                      tooltip: 'Logout',
                                      onPressed: () => {
                                            BlocProvider.of<AuthBloc>(context)
                                                .add(Logout()),
                                            Navigator.pushNamed(
                                                context, '/home',
                                                arguments: FormArguments(
                                                    "Successfully logged out."))
                                          }),
                              ]),
                          drawer: myDrawer(context, authenticate),
                          body: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 2.0),
                            child: GridView.count(
                              crossAxisCount: ResponsiveWrapper.of(context)
                                      .isSmallerThan(TABLET)
                                  ? 2
                                  : 3,
                              padding: EdgeInsets.all(3.0),
                              children: <Widget>[
                                makeDashboardItem(
                                    context,
                                    menuItems[1],
                                    "Current user: ${authenticate.user.firstName} "
                                        "${authenticate.user.lastName} ",
                                    "Employees: ${authenticate.company.employees.length}",
                                    ""),
                                makeDashboardItem(
                                    context,
                                    menuItems[2],
                                    "Opportunities: ${crm?.opportunities?.length ?? 0}",
                                    "Leads: ${crm?.leads?.length}",
                                    "Customers: ${crm?.customers?.length}"),
                                makeDashboardItem(
                                    context,
                                    menuItems[3],
                                    "Categories: ${categories?.length ?? 0}",
                                    "Products: ${products?.length ?? 0}",
                                    ""),
                                makeDashboardItem(
                                    context,
                                    menuItems[4],
                                    "Orders: ${(orders?.where((x) => x.supplierPartyId == authenticate.company.partyId))?.toList()?.length ?? 0}",
                                    "Customers: ${crm?.customers?.length}",
                                    ""),
                                makeDashboardItem(
                                    context,
                                    MenuItem(
                                        title: "Accounting",
                                        selectedImage:
                                            "assets/images/accounting.png"),
                                    " Assets: ${balanceSheet?.classInfoById?.asset?.totalPostedByTimePeriod?.all}",
                                    "",
                                    ""),
                                makeDashboardItem(
                                    context,
                                    menuItems[5],
                                    "Orders: ${(orders?.where((x) => x.customerPartyId == authenticate.company.partyId))?.toList()?.length ?? 0}",
                                    "Suppliers: ${crm?.suppliers?.length}",
                                    ""),
                              ],
                            ),
                          )));
                });
              });
            });
          });
        });
      }

      if (state is AuthUnauthenticated) {
        Authenticate authenticate = state.authenticate;
        return ScaffoldMessenger(
            key: scaffoldMessengerKey,
            child: Scaffold(
                appBar: AppBar(
                    title: companyLogo(context, authenticate,
                        authenticate?.company?.name ?? 'Company??')),
                body: Center(
                    child: Column(children: <Widget>[
                  SizedBox(height: 150),
                  Text("Login with an existing Id"),
                  RaisedButton(
                    autofocus: true,
                    child: Text('Login'),
                    onPressed: () async {
                      dynamic result =
                          await Navigator.pushNamed(context, '/login');
                      if (result)
                        Navigator.pushNamed(context, '/home',
                            arguments:
                                FormArguments("Successfully logged in."));
                    },
                  ),
                  SizedBox(height: 50),
                  Text(
                      "Or create a new company and you being the administrator"),
                  RaisedButton(
                    child: Text('Create a new company and admin'),
                    onPressed: () {
                      authenticate.company.partyId = null;
                      Navigator.popAndPushNamed(context, '/register');
                    },
                  ),
                ]))));
      }
      return LoadingIndicator();
    });
  }
}

Card makeDashboardItem(BuildContext context, MenuItem menuItem, String subTitle,
    String subTitle1, String subTitle2) {
  return Card(
      elevation: 1.0,
      margin: new EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, 1.0)),
        child: new InkWell(
          onTap: () {
            Navigator.pushNamed(context, menuItem.route,
                arguments: FormArguments());
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              SizedBox(height: 10.0),
              Center(child: Image.asset(menuItem.selectedImage, height: 80.0)),
              SizedBox(height: 10.0),
              Center(
                child: Text("${menuItem.title}",
                    style: TextStyle(fontSize: 25.0, color: Colors.black)),
              ),
              Center(
                child: Text(subTitle,
                    style: TextStyle(fontSize: 20.0, color: Colors.black)),
              ),
              Center(
                child: Text(subTitle1,
                    style: TextStyle(fontSize: 20.0, color: Colors.black)),
              ),
              Center(
                child: Text(subTitle2,
                    style: TextStyle(fontSize: 20.0, color: Colors.black)),
              )
            ],
          ),
        ),
      ));
}
