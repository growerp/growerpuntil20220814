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

import 'package:core/domains/common/functions/helper_functions.dart';
import 'package:core/widgets/dialogCloseButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:core/domains/domains.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../api_repository.dart';

class WebsiteCategoryDialog extends StatelessWidget {
  final String websiteId;
  final Category category;
  const WebsiteCategoryDialog(this.websiteId, this.category);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          ProductBloc(context.read<APIRepository>())..add(ProductFetch()),
      child: WebsiteCategoryDialogFull(websiteId, category),
    );
  }
}

class WebsiteCategoryDialogFull extends StatefulWidget {
  final String websiteId;
  final Category category;
  WebsiteCategoryDialogFull(this.websiteId, this.category);
  @override
  _CategoryState createState() => _CategoryState(category);
}

class _CategoryState extends State<WebsiteCategoryDialogFull> {
  final Category category;
  final _formKey = GlobalKey<FormState>();
  List<Product> _selectedProducts = [];
  late String classificationId;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  _CategoryState(this.category);

  @override
  void initState() {
    classificationId = GlobalConfiguration().get("classificationId");
    _selectedProducts = List.of(category.products);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        key: Key('WebsiteCategoryDialog'),
        insetPadding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ScaffoldMessenger(
            key: scaffoldMessengerKey,
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(clipBehavior: Clip.none, children: [
                  _showForm(),
                  Positioned(top: -10, right: -10, child: DialogCloseButton()),
                ]))));
  }

  Widget _showForm() {
    return BlocListener<WebsiteBloc, WebsiteState>(
      listener: (context, state) {
        if (state.status == WebsiteStatus.success) Navigator.of(context).pop();
        if (state.status == WebsiteStatus.failure)
          HelperFunctions.showMessage(context, state.message, Colors.red);
      },
      child: BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) async {
        switch (state.status) {
          case ProductStatus.failure:
            HelperFunctions.showMessage(context,
                'Error getting categories: ${state.message}', Colors.red);
            break;
          default:
        }
      }, builder: (context, state) {
        if (state.status == ProductStatus.success)
          return _categoryDialog(state);
        return CircularProgressIndicator();
      }),
    );
  }

  Widget _categoryDialog(ProductState state) {
    bool isPhone = ResponsiveWrapper.of(context).isSmallerThan(TABLET);
    return Center(
        child: Container(
            width: 400,
            padding: EdgeInsets.all(20),
            child: Form(
                key: _formKey,
                child: ListView(key: Key('listView'), children: <Widget>[
                  Center(
                      child: Text(
                    'Category #${category.categoryId.isEmpty ? " New" : category.categoryId}',
                    style: TextStyle(
                        fontSize: isPhone ? 10 : 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    key: Key('header'),
                  )),
                  SizedBox(height: 30),
                  Center(
                      child: Text(
                    category.categoryName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                  SizedBox(height: 30),
                  ElevatedButton(
                    key: Key('addProducts'),
                    onPressed: () async {
                      var result = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return MultiSelect<Product>(
                              title: 'Select one or more products',
                              items: state.products,
                              selectedItems: _selectedProducts,
                            );
                          });
                      if (result != null) {
                        setState(() {
                          _selectedProducts = result;
                        });
                      }
                    },
                    child: const Text('Select one or more products '),
                  ),
                  Wrap(
                    spacing: 10.0,
                    children: _selectedProducts
                        .map((Product e) => Chip(
                            label: Text(
                              e.productName!,
                              key: Key(e.productId),
                            ),
                            deleteIcon: const Icon(
                              Icons.cancel,
                              key: Key("deleteChip"),
                            ),
                            onDeleted: () async {
                              setState(() {
                                _selectedProducts.remove(e);
                              });
                            }))
                        .toList(),
                  ),
                  Row(children: [
                    ElevatedButton(
                        key: Key('cancel'),
                        child: Text('Cancel'),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        }),
                    SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                          key: Key('update'),
                          child: Text('Update'),
                          onPressed: () async {
                            context.read<WebsiteBloc>().add(WebsiteUpdate(
                                    Website(
                                        id: widget.websiteId,
                                        websiteCategories: [
                                      widget.category
                                          .copyWith(products: _selectedProducts)
                                    ])));
                          }),
                    )
                  ]),
                ]))));
  }
}
