import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/blocs/@blocs.dart';
import 'package:core/widgets/@widgets.dart';
import 'package:models/@models.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class CategoriesForm extends StatefulWidget {
  const CategoriesForm();
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<CategoriesForm> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  CategoryBloc _categoryBloc;
  Authenticate authenticate;
  _CategoriesState();
  int limit;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _categoryBloc = BlocProvider.of<CategoryBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      limit = (MediaQuery.of(context).size.height / 35).round();
    });
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) {
        authenticate = state?.authenticate;
        return BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
          if (state is CategoryProblem)
            return Center(child: Text("${state.errorMessage}"));
          if (state is CategorySuccess) {
            if (state.categories.isEmpty)
              return Center(child: Text('no categories'));
            return ListView.builder(
              itemCount: state.hasReachedMax
                  ? state.categories.length + 1
                  : state.categories.length + 2,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0)
                  return ListTile(
                      onTap: null,
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                      ),
                      title: Column(children: [
                        Row(children: <Widget>[
                          Expanded(
                              child: Text("Name", textAlign: TextAlign.center)),
                          if (!ResponsiveWrapper.of(context)
                              .isSmallerThan(TABLET))
                            Expanded(
                                child: Text("Description",
                                    textAlign: TextAlign.center)),
                          Expanded(
                              child: Text("Nbr.of Products",
                                  textAlign: TextAlign.center)),
                        ]),
                        Divider(color: Colors.black),
                      ]),
                      trailing: Text(' '));
                index -= 1;
                return index >= state.categories.length
                    ? BottomLoader()
                    : Dismissible(
                        key: Key(state.categories[index].categoryId),
                        direction: DismissDirection.startToEnd,
                        child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green,
                              child: state.categories[index].image != null
                                  ? Image.memory(
                                      state.categories[index]?.image,
                                      height: 100,
                                    )
                                  : Text(
                                      "${state.categories[index]?.categoryName}"),
                            ),
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                        "${state.categories[index]?.categoryName}")),
                                if (!ResponsiveWrapper.of(context)
                                    .isSmallerThan(TABLET))
                                  Expanded(
                                      child: Text(
                                          "${state.categories[index]?.description}",
                                          textAlign: TextAlign.center)),
                                Expanded(
                                    child: Text(
                                        "${state.categories[index].nbrOfProducts} ",
                                        textAlign: TextAlign.center)),
                              ],
                            ),
                            onTap: () async {
                              dynamic result = await Navigator.pushNamed(
                                  context, '/category',
                                  arguments: FormArguments(
                                      null, 0, state.categories[index]));
                              setState(() {
                                if (result is ProductCategory)
                                  state.categories
                                      .replaceRange(index, index + 1, [result]);
                              });
                            },
                            trailing: IconButton(
                              icon: Icon(Icons.delete_forever),
                              onPressed: () {
                                _categoryBloc.add(
                                    DeleteCategory(state.categories[index]));
                                setState(() {
                                  state.categories.removeAt(index);
                                });
                              },
                            )));
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        });
      }
      return Container(child: Center(child: Text("Not Authorized!")));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _categoryBloc.add(FetchCategory(
          companyPartyId: authenticate.company.partyId, limit: limit));
    }
  }
}
