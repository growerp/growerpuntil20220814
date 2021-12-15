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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import '../catalog.dart';

class CategoryListHeader extends StatelessWidget {
  const CategoryListHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryBloc = BlocProvider.of<CategoryBloc>(context);
    String searchString = '';
    return Material(
        child: ListTile(
            leading: GestureDetector(
                key: Key('search'),
                onTap: (() {
                  if (categoryBloc.state.search) {
                    categoryBloc.add(CategorySearchOff());
                    categoryBloc.add(CategoryFetch(refresh: true));
                  } else
                    categoryBloc.add(CategorySearchOn());
                }),
                child: Image.asset(
                  'assets/images/search.png',
                  height: 30,
                )),
            title: categoryBloc.state.search
                ? Row(children: <Widget>[
                    Expanded(
                        child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        hintText: "search in ID, name and description...",
                      ),
                      onChanged: ((value) {
                        searchString = value;
                      }),
                      onSubmitted: ((value) {
                        categoryBloc.add(CategoryFetch(searchString: value));
                        categoryBloc.add(categoryBloc.state.search
                            ? CategorySearchOff()
                            : CategorySearchOn());
                      }),
                    )),
                    ElevatedButton(
                        key: Key('searchButton'),
                        child: Text('Search'),
                        onPressed: () {
                          categoryBloc
                              .add(CategoryFetch(searchString: searchString));
                          searchString = '';
                        })
                  ])
                : Column(children: [
                    Row(children: <Widget>[
                      Expanded(
                          child: Text("Name", textAlign: TextAlign.center)),
                      if (!ResponsiveWrapper.of(context).isSmallerThan(TABLET))
                        Expanded(
                            child: Text("Description",
                                textAlign: TextAlign.center)),
                      Expanded(
                          child: Text("Nbr.of Products",
                              textAlign: TextAlign.center)),
                    ]),
                    Divider(color: Colors.black),
                  ]),
            trailing: Text(' ')));
  }
}
