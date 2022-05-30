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
import '../../../api_repository.dart';
import '../../common/functions/helper_functions.dart';
import '../../domains.dart';

class CategoryListForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          CategoryBloc(context.read<APIRepository>())
            ..add(CategoryFetch(
                companyPartyId: context
                    .read<AuthBloc>()
                    .state
                    .authenticate!
                    .company!
                    .partyId!)),
      child: CategoryList(),
    );
  }
}

class CategoryList extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<CategoryList> {
  final _scrollController = ScrollController();
  late bool search;
  late CategoryBloc _categoryBloc;

  @override
  void initState() {
    super.initState();
    search = false;
    _categoryBloc = context.read<CategoryBloc>();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state.status == CategoryStatus.failure)
          HelperFunctions.showMessage(context, '${state.message}', Colors.red);
        if (state.status == CategoryStatus.success) {
          HelperFunctions.showMessage(
              context, '${state.message}', Colors.green);
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case CategoryStatus.failure:
            return Center(
                child: Text('failed to fetch categories: ${state.message}'));
          case CategoryStatus.success:
            return Scaffold(
                floatingActionButton: FloatingActionButton(
                    key: Key("addNew"),
                    onPressed: () async {
                      await showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            return BlocProvider.value(
                                value: _categoryBloc,
                                child: CategoryDialog(Category()));
                          });
                    },
                    tooltip: 'Add New',
                    child: Icon(Icons.add)),
                body: RefreshIndicator(
                    onRefresh: (() async => context
                        .read<CategoryBloc>()
                        .add(const CategoryFetch(refresh: true))),
                    child: ListView.builder(
                      key: Key('listView'),
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: state.hasReachedMax
                          ? state.categories.length + 1
                          : state.categories.length + 2,
                      controller: _scrollController,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0)
                          return Column(children: [
                            CategoryListHeader(),
                            Visibility(
                                visible: state.categories.isEmpty,
                                child: const Center(
                                    heightFactor: 20,
                                    child: Text('No categories found',
                                        key: Key('empty'),
                                        textAlign: TextAlign.center)))
                          ]);
                        index--;
                        return index >= state.categories.length
                            ? BottomLoader()
                            : Dismissible(
                                key: Key('categoryItem'),
                                direction: DismissDirection.startToEnd,
                                child: CategoryListItem(
                                    category: state.categories[index],
                                    index: index));
                      },
                    )));
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<CategoryBloc>().add(CategoryFetch());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
