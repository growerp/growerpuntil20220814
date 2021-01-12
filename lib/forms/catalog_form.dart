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
import 'package:responsive_framework/responsive_framework.dart';
import 'package:models/models.dart';
import 'package:core/blocs/@blocs.dart';
import 'package:core/helper_functions.dart';
import 'package:core/widgets/@widgets.dart';
import '@forms.dart';

class CatalogForm extends StatelessWidget {
  final FormArguments formArguments;
  CatalogForm(this.formArguments);
  @override
  Widget build(BuildContext context) {
    var a = (formArguments) =>
        (CatalogFormHeader(formArguments.message, formArguments.object));
    return ShowNavigationRail(a(formArguments), 3, formArguments.object);
  }
}

class CatalogFormHeader extends StatefulWidget {
  final String message;
  final Authenticate authenticate;
  const CatalogFormHeader([this.message, this.authenticate]);
  @override
  _CatalogFormStateHeader createState() =>
      _CatalogFormStateHeader(message, authenticate);
}

class _CatalogFormStateHeader extends State<CatalogFormHeader> {
  final String message;
  Authenticate authenticate;
  List<Product> products;
  List<ProductCategory> categories;

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  _CatalogFormStateHeader([this.message, this.authenticate]) {
    HelperFunctions.showTopMessage(scaffoldMessengerKey, message);
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _tabScreens = <Widget>[ProductsForm(), CategoriesForm()];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) authenticate = state.authenticate;
      return ScaffoldMessenger(
          key: scaffoldMessengerKey,
          child: DefaultTabController(
              length: _tabScreens.length,
              child: Scaffold(
                  appBar: AppBar(
                      bottom:
                          !ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                              ? TabBar(
                                  onTap: (index) {
                                    _selectedIndex = index;
                                  },
                                  labelPadding: EdgeInsets.all(10.0),
                                  labelColor: Colors.black,
                                  unselectedLabelColor: Colors.white,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  indicator: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      color: Colors.white),
                                  tabs: [
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Products",
                                          style: optionStyle,
                                        )),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Categories",
                                          style: optionStyle,
                                        )),
                                  ],
                                )
                              : null,
                      title: companyLogo(
                          context, authenticate, 'Company Catalog.'),
                      automaticallyImplyLeading:
                          ResponsiveWrapper.of(context).isSmallerThan(TABLET)),
                  bottomNavigationBar:
                      ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                          ? BottomNavigationBar(
                              items: const <BottomNavigationBarItem>[
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.home),
                                  label: 'Products',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.business),
                                  label: 'Categories',
                                ),
                              ],
                              currentIndex: _selectedIndex,
                              selectedItemColor: Colors.amber[800],
                              onTap: _onItemTapped,
                            )
                          : null,
                  floatingActionButton: FloatingActionButton(
                      onPressed: () async {
                        dynamic product, category;
                        _selectedIndex == 0
                            ? product = await Navigator.pushNamed(
                                context, '/product',
                                arguments: FormArguments(
                                    'Enter the product information'))
                            : category = Navigator.pushNamed(
                                context, '/category',
                                arguments: FormArguments(
                                    'Enter the category information'));
                        setState(() {
                          if (product != null) products.add(product);
                          if (category != null) categories.add(product);
                        });
                      },
                      tooltip: 'Add New',
                      child: Icon(Icons.add)),
                  drawer: myDrawer(context, authenticate),
                  body: Builder(builder: (BuildContext context) {
                    return ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                        ? Center(child: _tabScreens.elementAt(_selectedIndex))
                        : TabBarView(children: _tabScreens);
                  }))));
    });
  }
}
