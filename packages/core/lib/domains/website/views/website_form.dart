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
import 'package:reorderables/reorderables.dart';
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
  List<Content> _updatedContent = [];
  List<Category> _updatedCategories = [];
  List<Category> _selectedCategories = [];
  List<Category> _availableCategories = [];
  String changedTitle = '';

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
            case WebsiteStatus.success:
              _updatedContent = List.of(state.website!.websiteContent);
              _updatedCategories = List.of(state.website!.websiteCategories);
              _selectedCategories = List.of(state.website!.productCategories);
              return Scaffold(body: Center(child: _showForm(state)));
            case WebsiteStatus.failure:
              return Center(child: Text("error happened"));
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
      contentButtons.add(InputChip(
        key: Key(content.path),
        label: Text(
          content.title,
        ),
        onPressed: () {
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                return BlocProvider.value(
                    value: _websiteBloc,
                    child: EditorDialog(state.website!.id, content));
              });
          setState(() {});
        },
        deleteIcon: const Icon(
          Icons.cancel,
          key: Key("deleteChip"),
        ),
        onDeleted: () async {
          _updatedContent[index] = _updatedContent[index].copyWith(title: '');
          context.read<WebsiteBloc>().add(WebsiteUpdate(
              Website(id: state.website!.id, websiteContent: _updatedContent)));
          setState(() {});
        },
      ));
    });
    contentButtons.add(IconButton(
        iconSize: 30,
        icon: Icon(Icons.add_circle),
        color: Colors.deepOrange,
        padding: const EdgeInsets.all(0.0),
        onPressed: () async {
          Content newContent = Content(text: '# new title here...');
          await showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                return BlocProvider.value(
                    value: _websiteBloc,
                    child: EditorDialog(state.website!.id, newContent));
              });
          setState(() {
//            if (result != null) _updatedContent!.add(result);
          });
        }));

    // create website category buttons
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
    });

    // create product browse categories
    List<Widget> browseCatButtons = [];
    state.website!.productCategories.asMap().forEach((index, category) {
      browseCatButtons.add(InputChip(
        label: Text(
          category.categoryName,
          key: Key(category.categoryName),
        ),
        deleteIcon: const Icon(
          Icons.cancel,
          key: Key("deleteChip"),
        ),
        onDeleted: () async {
          setState(() {
            _selectedCategories.removeAt(index);
            if (_selectedCategories.isEmpty)
              _selectedCategories.add(Category(categoryId: 'allDelete'));
            context.read<WebsiteBloc>().add(WebsiteUpdate(Website(
                id: state.website!.id,
                productCategories: _selectedCategories)));
          });
        },
      ));
    });

    browseCatButtons.add(IconButton(
      iconSize: 30,
      icon: Icon(Icons.add_circle),
      color: Colors.deepOrange,
      padding: const EdgeInsets.all(0.0),
      onPressed: () async {
        var result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return MultiSelect<Category>(
                title: 'Select one or more categories',
                items: _availableCategories,
                selectedItems: _selectedCategories,
              );
            });
        if (result != null) {
          setState(() {
            _selectedCategories = result;
          });
          context.read<WebsiteBloc>().add(WebsiteUpdate(Website(
              id: state.website!.id, productCategories: _selectedCategories)));
        }
      },
    ));

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
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            key: Key('header'),
                          )),
                          SizedBox(height: 10),
                          Link(
                              uri: Uri.parse(foundation.kReleaseMode
                                  ? "https://${state.website?.hostName}"
                                  : "http://${state.website!.id}.localhost:8080/store"),
                              target: LinkTarget.blank,
                              builder: (BuildContext context,
                                  FollowLink? followLink) {
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
                          Row(children: [
                            Expanded(
                              child: TextFormField(
                                  key: Key('title'),
                                  initialValue: state.website!.title,
                                  decoration: new InputDecoration(
                                      labelText: 'Title of the website'),
                                  onChanged: (value) {
                                    changedTitle = value;
                                  }),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                                key: Key('update'),
                                child: Text('update'),
                                onPressed: () async {
                                  _websiteBloc.add(WebsiteUpdate(Website(
                                      id: state.website!.id,
                                      title: changedTitle)));
                                }),
                          ]),
                          SizedBox(height: 30),
                          Text(
                            'Text sections',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Can change order with long press',
                            style: TextStyle(fontSize: 10),
                          ),
                          ReorderableWrap(
                              runSpacing: 10,
                              onReorder: (int oldIndex, int newIndex) {
                                var content =
                                    List.of(state.website!.websiteContent);
                                content.insert(newIndex, content[oldIndex]);
                                if (newIndex < oldIndex)
                                  content.removeAt(oldIndex + 1);
                                else
                                  content.removeAt(oldIndex);
                                int index = 1;
                                for (int i = 0; i < content.length; i++)
                                  content[i] = content[i]
                                      .copyWith(seqId: index++, text: '');
                                context.read<WebsiteBloc>().add(WebsiteUpdate(
                                    Website(
                                        id: state.website!.id,
                                        websiteContent: content)));
                              },
                              spacing: 10,
                              children: contentButtons),
                          SizedBox(height: 30),
                          Text(
                            'Home Page Categories',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Wrap(children: catButtons, spacing: 10),
                          SizedBox(height: 30),
                          Text(
                            'Shop Categories',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Wrap(children: browseCatButtons, spacing: 10),
                        ]))))));
  }
}
