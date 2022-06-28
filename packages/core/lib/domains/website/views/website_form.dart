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
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domains/domains.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/link.dart';
import '../../../api_repository.dart';

class WebsiteForm extends StatelessWidget {
  final Key? key;
  final UserGroup userGroup;
  const WebsiteForm({
    this.key,
    required this.userGroup,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            WebsiteBloc(context.read<APIRepository>())..add(WebsiteFetch()),
        child: BlocProvider(
          create: (BuildContext context) =>
              CategoryBloc(context.read<APIRepository>())..add(CategoryFetch()),
          child: WebsitePage(),
        ));
  }
}

class WebsitePage extends StatefulWidget {
  @override
  _WebsiteState createState() => _WebsiteState();
}

class _WebsiteState extends State<WebsitePage> {
  final _formKey = GlobalKey<FormState>();

  late WebsiteBloc _websiteBloc;
  List<Content>? _updatedContent;
  List<Category>? _updatedCategories;
  List<Category>? _selectedCategories;
  List<Category>? _availableCategories;

  @override
  void initState() {
    super.initState();
    _websiteBloc = context.read<WebsiteBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) async {
      switch (state.status) {
        case CategoryStatus.failure:
          HelperFunctions.showMessage(context,
              'Error getting categories: ${state.message}', Colors.red);
          break;
        default:
      }
    }, builder: (context, state) {
      if (state.status == CategoryStatus.success) {
        _availableCategories = state.categories;
        return BlocConsumer<WebsiteBloc, WebsiteState>(
            listener: (context, state) {
          switch (state.status) {
            case WebsiteStatus.success:
              HelperFunctions.showMessage(
                  context, '${state.message}', Colors.green);
              break;
            case WebsiteStatus.failure:
              HelperFunctions.showMessage(
                  context, '${state.message}', Colors.red);
              break;
            default:
          }
        }, builder: (context, state) {
          switch (state.status) {
            case WebsiteStatus.failure:
              return Center(
                  child: Text('failed to fetch website info ${state.message}'));
            case WebsiteStatus.success:
              if (_updatedContent == null)
                _updatedContent = List.of(state.website!.websiteContent);
              if (_updatedCategories == null)
                _updatedCategories = List.of(state.website!.websiteCategories);
              if (_selectedCategories == null)
                _selectedCategories = List.of(state.website!.productCategories);
              return Scaffold(body: Center(child: _showForm(state)));
            default:
              return LoadingIndicator();
          }
        });
      }
      return LoadingIndicator();
    });
  }

  Widget _showForm(WebsiteState state) {
    // create content buttons
    List<Widget> contentButtons = [];
    state.website!.websiteContent.asMap().forEach((index, content) {
      contentButtons.add(ElevatedButton(
          key: Key(content.id),
          child: Text(content.id),
          onPressed: () async {
            showDialog(
                barrierDismissible: true,
                context: context,
                builder: (BuildContext context) {
                  return BlocProvider.value(
                      value: _websiteBloc,
                      child: EditorDialog(state.website!.id, content));
                });
          }));
      contentButtons.add(SizedBox(width: 10));
    });

    // create category buttons
    List<Widget> catButtons = [];
    state.website!.websiteCategories.asMap().forEach((index, category) {
      catButtons.add(ElevatedButton(
          key: Key(category.categoryName),
          child: Text(
            category.categoryName,
          ),
          onPressed: () async {
            await showDialog(
                barrierDismissible: true,
                context: context,
                builder: (BuildContext context) {
                  return BlocProvider.value(
                      value: _websiteBloc,
                      child:
                          WebsiteCategoryDialog(state.website!.id, category));
                });
          }));
      catButtons.add(SizedBox(width: 10));
    });
    String title =
        state.website!.websiteContent.firstWhere((e) => e.id == 'title').text;
    bool isPhone = ResponsiveWrapper.of(context).isSmallerThan(TABLET);
    return Center(
        child: Container(
            width: 400,
            child: SingleChildScrollView(
                key: Key('listView'),
                child: Form(
                    key: _formKey,
                    child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(children: [
                          Center(
                              child: Text(
                            'id:#${state.website?.id}',
                            style: TextStyle(
                                fontSize: isPhone ? 10 : 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            key: Key('header'),
                          )),
                          SizedBox(height: 10),
                          Link(
                              uri: Uri.parse(foundation.kReleaseMode
                                  ? "https://${state.website?.hostName}"
                                  : "http://10.0.2.2:8080/store"),
                              builder: (context, followLink) {
                                return InkWell(
                                  onTap: followLink,
                                  child: Text(
                                    "${state.website?.hostName}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                );
                              }),
                          SizedBox(height: 30),
                          Center(
                              child: Text(
                            title,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            key: Key('titleText'),
                          )),
                          SizedBox(height: 30),
                          Text(
                            'Text sections',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Wrap(children: contentButtons),
                          SizedBox(height: 30),
                          Text(
                            'Website Categories',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Wrap(children: catButtons),
                          SizedBox(height: 30),
                          Text(
                            'Product Categories',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  key: Key('addCategories'),
                                  onPressed: () async {
                                    var result = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return MultiSelect<Category>(
                                            title:
                                                'Select one or more categories',
                                            items: _availableCategories!,
                                            selectedItems: _selectedCategories!,
                                          );
                                        });
                                    if (result != null) {
                                      setState(() {
                                        _selectedCategories = result;
                                      });
                                      context.read<WebsiteBloc>().add(
                                          WebsiteUpdate(Website(
                                              id: state.website!.id,
                                              productCategories:
                                                  _selectedCategories!)));
                                    }
                                  },
                                  child: const Text(
                                      'modify available category list'),
                                ),
                                SizedBox(height: 10),
                                Wrap(
                                  spacing: 10.0,
                                  children: _selectedCategories!
                                      .map((Category e) => Chip(
                                            label: Text(
                                              e.categoryName,
                                              key: Key(e.categoryName),
                                            ),
                                            deleteIcon: const Icon(
                                              Icons.cancel,
                                              key: Key("deleteChip"),
                                            ),
                                            onDeleted: () async {
                                              setState(() {
                                                _selectedCategories!.remove(e);
                                              });
                                              context.read<WebsiteBloc>().add(
                                                  WebsiteUpdate(Website(
                                                      id: state.website!.id,
                                                      productCategories:
                                                          _selectedCategories!)));
                                            },
                                          ))
                                      .toList(),
                                )
                              ])
                        ]))))));
  }
}
