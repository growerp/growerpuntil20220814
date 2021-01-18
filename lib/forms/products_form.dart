import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/blocs/@blocs.dart';
import 'package:core/widgets/@widgets.dart';
import 'package:models/models.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class ProductsForm extends StatefulWidget {
  const ProductsForm();
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<ProductsForm> {
  final _scrollController = ScrollController();
  double _scrollThreshold = 200.0;
  ProductBloc _productBloc;
  Authenticate authenticate;
  int productLimit;
  _ProductsState();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _productBloc = BlocProvider.of<ProductBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      productLimit = (MediaQuery.of(context).size.height / 35).round();
    });
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) {
        authenticate = state?.authenticate;
        return BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
          if (state is ProductProblem)
            return Center(child: Text("${state.errorMessage}"));
          if (state is ProductSuccess) {
            if (state.products.isEmpty)
              return Center(child: Text('no products'));
            return ListView.builder(
              itemCount: state.hasReachedMax
                  ? state.products.length + 1
                  : state.products.length + 2,
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
                          Expanded(
                              child: Text("Description",
                                  textAlign: TextAlign.center)),
                          Expanded(
                              child:
                                  Text("Price", textAlign: TextAlign.center)),
                          Expanded(
                              child: Text("Category",
                                  textAlign: TextAlign.center)),
                        ]),
                        Divider(color: Colors.black),
                      ]),
                      trailing: Text(' '));
                index -= 1;
                return index >= state.products.length
                    ? BottomLoader()
                    : Dismissible(
                        key: Key(state.products[index].productId),
                        direction: DismissDirection.startToEnd,
                        child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green,
                              child: state.products[index].image != null
                                  ? Image.memory(
                                      state.products[index]?.image,
                                      height: 100,
                                    )
                                  : Text(
                                      "${state.products[index]?.productName}"),
                            ),
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                        "${state.products[index]?.productName}")),
                                if (!ResponsiveWrapper.of(context)
                                    .isSmallerThan(TABLET))
                                  Expanded(
                                      child: Text(
                                          "${state.products[index]?.description}",
                                          textAlign: TextAlign.center)),
                                Expanded(
                                    child: Text(
                                        "${authenticate.company.currencyId} "
                                        "${state.products[index]?.price}",
                                        textAlign: TextAlign.center)),
                                Expanded(
                                    child: Text(
                                        "${state.products[index]?.categoryName}",
                                        textAlign: TextAlign.center)),
                              ],
                            ),
                            onTap: () async {
                              dynamic result = await Navigator.pushNamed(
                                  context, '/product',
                                  arguments: FormArguments(
                                      null, 0, state.products[index]));
                              setState(() {
                                if (result is Product)
                                  state.products
                                      .replaceRange(index, index + 1, [result]);
                              });
                            },
                            trailing: IconButton(
                              icon: Icon(Icons.delete_forever),
                              onPressed: () {
                                _productBloc
                                    .add(DeleteProduct(state.products[index]));
                                setState(() {
                                  state.products.removeAt(index);
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
//    print(
//        "=====onScrol cur: ${_scrollController.position.maxScrollExtent - _scrollController.position.pixels} treshold: _${_scrollThreshold}");
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _productBloc
          .add(ProductFetched(authenticate.company.partyId, productLimit));
    }
  }
}
