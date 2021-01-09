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

import 'package:core/forms/@forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:models/models.dart';
import 'package:core/blocs/@blocs.dart';
import 'package:core/helper_functions.dart';
import 'package:core/widgets/@widgets.dart';

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
  Catalog catalog;
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) authenticate = state.authenticate;
      return ScaffoldMessenger(
          key: scaffoldMessengerKey,
          child: DefaultTabController(
              length: 2,
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
                          if (category != null) products.add(product);
                        });
                      },
                      tooltip: 'Add New',
                      child: Icon(Icons.add)),
                  drawer: myDrawer(context, authenticate),
                  body: BlocListener<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthProblem)
                          HelperFunctions.showMessage(
                              context, '${state.errorMessage}', Colors.red);
                        if (state is AuthLoading)
                          HelperFunctions.showMessage(
                              context, '${state.message}', Colors.red);
                      },
                      child: BlocConsumer<CatalogBloc, CatalogState>(
                          listener: (context, state) {
                        if (state is CatalogProblem)
                          HelperFunctions.showMessage(
                              context, '${state.errorMessage}', Colors.red);
                        if (state is CatalogLoaded)
                          HelperFunctions.showMessage(
                              context, '${state.message}', Colors.green);
                        if (state is CatalogLoading)
                          HelperFunctions.showMessage(
                              context, '${state.message}', Colors.green);
                      }, builder: (context, state) {
                        if (state is CatalogLoaded) {
                          catalog = state.catalog;
                          products = catalog.products;
                          categories = catalog.categories;
                        }
                        List<Widget> _widgetOptions = <Widget>[
                          productList(),
                          categoryList(catalog)
                        ];
                        return ResponsiveWrapper.of(context)
                                .isSmallerThan(TABLET)
                            ? Center(
                                child: _widgetOptions.elementAt(_selectedIndex))
                            : TabBarView(children: _widgetOptions);
                      })))));
    });
  }

  Widget productList() {
    if (catalog?.categories == null)
      return FatalErrorForm(
          "No products yet, enter categories first\n "
              "they are mandatory on products",
          '/category',
          "Create category");
    else
      return CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
              child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
            ),
            title: Column(children: [
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text("Product name", textAlign: TextAlign.center)),
                  if (!ResponsiveWrapper.of(context).isSmallerThan(TABLET))
                    Expanded(
                        child:
                            Text("Description", textAlign: TextAlign.center)),
                  Expanded(child: Text("Price", textAlign: TextAlign.center)),
                  Expanded(
                      child: Text("Category", textAlign: TextAlign.center)),
                ],
              ),
              Divider(color: Colors.black),
            ]),
          )),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return InkWell(
                  onTap: () async {
                    dynamic product = await Navigator.pushNamed(
                        context, '/product',
                        arguments: FormArguments(null, 0, products[index]));
                    setState(() {
                      if (product != null)
                        products.replaceRange(index, index + 1, [product]);
                    });
                  },
                  onLongPress: () async {
                    bool result = await confirmDialog(
                        context,
                        "${products[index].productName}",
                        "Delete this product?");
                    if (result) {
                      BlocProvider.of<CatalogBloc>(context)
                          .add(DeleteProduct(products[index]));
                      setState(() {
                        HelperFunctions.showMessage(
                            context, "Product deleted", Colors.green);
                      });
                    }
                  },
                  child: ListTile(
                    //return  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: products[index]?.image != null
                          ? Image.memory(
                              products[index]?.image,
                              height: 100,
                            )
                          : Text(products[index]?.productName != null
                              ? products[index]?.productName[0]
                              : '?'),
                    ),
                    title: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text("${products[index]?.productName}")),
                        if (!ResponsiveWrapper.of(context)
                            .isSmallerThan(TABLET))
                          Expanded(
                              child: Text("${products[index]?.description}",
                                  textAlign: TextAlign.center)),
                        Expanded(
                            child: Text(
                                "${authenticate.company.currencyId} "
                                "${products[index]?.price}",
                                textAlign: TextAlign.center)),
                        Expanded(
                            child: Text("${products[index]?.categoryName}",
                                textAlign: TextAlign.center)),
                      ],
                    ),
                  ),
                );
              },
              childCount: products == null ? 0 : products?.length,
            ),
          ),
        ],
      );
  }

  Widget categoryList(catalog) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          // you could add any widget
          child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
              ),
              title: Column(children: [
                Row(
                  children: <Widget>[
                    Expanded(
                        child:
                            Text("Category Name", textAlign: TextAlign.center)),
                    Expanded(
                        child:
                            Text("Description", textAlign: TextAlign.center)),
                    Expanded(
                        child:
                            Text("nbrOfProducts", textAlign: TextAlign.center)),
                  ],
                ),
                Divider(color: Colors.black),
              ])),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return InkWell(
                onTap: () async {
                  dynamic result = await Navigator.pushNamed(
                      context, '/category',
                      arguments: FormArguments(null, 1, categories[index]));
                  setState(() {
                    if (result is Catalog) categories = result?.categories;
                  });
                  HelperFunctions.showMessage(
                      context,
                      'Category ${categories[index].categoryName}  modified',
                      Colors.green);
                },
                onLongPress: () async {
                  bool result = await confirmDialog(
                      context,
                      "${categories[index].categoryName}",
                      "Delete this category?");
                  if (result) {
                    BlocProvider.of<CatalogBloc>(context)
                        .add(DeleteCategory(categories[index]));
                    setState(() {
                      HelperFunctions.showMessage(
                          context, "Category deleted", Colors.green);
                    });
                  }
                },
                child: ListTile(
                  //return  ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: categories[index]?.image != null
                        ? Image.memory(categories[index]?.image)
                        : Text(categories[index]?.categoryName[0]),
                  ),
                  title: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text("${categories[index].categoryName}")),
                      Expanded(child: Text("${categories[index].description}")),
                      Expanded(
                          child: Text("${categories[index].nbrOfProducts}",
                              textAlign: TextAlign.center)),
                    ],
                  ),
                ),
              );
            },
            childCount: categories == null ? 0 : categories?.length,
          ),
        ),
      ],
    );
  }
}
