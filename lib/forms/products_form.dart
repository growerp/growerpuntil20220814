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
import '../models/@models.dart';
import '../blocs/@blocs.dart';
import '../helper_functions.dart';
import '../routing_constants.dart';
import '../widgets/@widgets.dart';

class ProductsForm extends StatelessWidget {
  final FormArguments formArguments;
  ProductsForm(this.formArguments);
  @override
  Widget build(BuildContext context) {
    var a = (formArguments) =>
        (ProductsFormHeader(formArguments.authenticate, formArguments.message));
    return CheckConnectAndAddRail(a(formArguments), 3);
  }
}

class ProductsFormHeader extends StatefulWidget {
  final Authenticate authenticate;
  final String message;
  const ProductsFormHeader(this.authenticate, this.message);
  @override
  _ProductsFormStateHeader createState() =>
      _ProductsFormStateHeader(authenticate, message);
}

class _ProductsFormStateHeader extends State<ProductsFormHeader> {
  final Authenticate authenticate;
  final String message;

  _ProductsFormStateHeader(this.authenticate, this.message);
  @override
  Widget build(BuildContext context) {
    Authenticate authenticate = this.authenticate;
    Catalog catalog;
    return Scaffold(
        appBar: AppBar(
            title: companyLogo(context, authenticate, 'Product List'),
            automaticallyImplyLeading:
                ResponsiveWrapper.of(context).isSmallerThan(TABLET)),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            dynamic user = await Navigator.pushNamed(context, ProductRoute,
                arguments: FormArguments(authenticate));
            setState(() {
              if (user?.partyId != null)
                authenticate.company.employees.add(user);
            });
          },
          tooltip: 'Add new user',
          child: Icon(Icons.add),
        ),
        body:
            BlocConsumer<CatalogBloc, CatalogState>(listener: (context, state) {
          if (state is CatalogProblem) {
            HelperFunctions.showMessage(
                context, '${state.errorMessage}', Colors.red);
          }
//          if (state is CatalogLoaded) {
//            HelperFunctions.showMessage(
//                context, '${state.message}', Colors.green);
//          }
        }, builder: (context, state) {
          if (state is CatalogLoaded) catalog = state.catalog;
          return productList(context, catalog);
        }));
  }

  Widget productList(context, Catalog catalog) {
    List<Product> products = catalog?.products;
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          // you could add any widget
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
            ),
            title: Row(
              children: <Widget>[
                Expanded(child: Text(" ", textAlign: TextAlign.center)),
                Expanded(child: Text("Name", textAlign: TextAlign.center)),
                if (!ResponsiveWrapper.of(context).isSmallerThan(DESKTOP))
                  Expanded(
                      child: Text("productCategoryId",
                          textAlign: TextAlign.center)),
                Expanded(child: Text("price", textAlign: TextAlign.center)),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return InkWell(
                onTap: () async {
                  dynamic user = await Navigator.pushNamed(
                      context, ProductRoute,
                      arguments:
                          FormArguments(authenticate, null, products[index]));
                  setState(() {
                    if (user != null)
                      products.replaceRange(index, index + 1, [user]);
                  });
                },
                onLongPress: () async {
                  bool result = await confirmDialog(context,
                      "${products[index].name}", "Delete this product?");
                  if (result) {
                    BlocProvider.of<CatalogBloc>(context)
                        .add(DeleteProduct(catalog, products[index].productId));
                    setState(() {
                      products.removeAt(index);
                    });
                  }
                },
                child: ListTile(
                  //return  ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: products[index]?.image != null
                        ? Image.memory(products[index]?.image)
                        : Text(products[index]?.name[0]),
                  ),
                  title: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text("${products[index].name}, "
                              "[${products[index].productId}]")),
                      Expanded(
                          child: Text("${products[index].name}",
                              textAlign: TextAlign.center)),
                      Expanded(
                          child: Text("${products[index].price}",
                              textAlign: TextAlign.center)),
                      Expanded(
                          child: Text("${products[index].productCategoryId}",
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
}
