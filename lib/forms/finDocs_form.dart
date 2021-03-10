import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/blocs/@blocs.dart';
import 'package:core/widgets/@widgets.dart';
import 'package:core/helper_functions.dart';
import 'package:models/@models.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class FinDocsForm extends StatefulWidget {
  final sales, docType;
  const FinDocsForm({this.sales, this.docType});
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<FinDocsForm> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  FinDocBloc _finDocBloc;
  Authenticate authenticate;
  int tab;
  int limit = 20;
  bool showSearchField;
  String searchString;

  _OrdersState();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    showSearchField = false;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      limit = (MediaQuery.of(context).size.height / 35).round();
      if (widget.docType == 'order') {
        if (widget.sales) {
          tab = 4;
          _finDocBloc = BlocProvider.of<SalesFinDocBloc>(context)
            ..add(FetchFinDoc(limit: limit));
        } else {
          tab = 5;
          _finDocBloc = BlocProvider.of<PurchFinDocBloc>(context)
            ..add(FetchFinDoc(limit: limit));
        }
      }
      if (widget.docType == 'invoice') {
        if (widget.sales) {
          tab = 0;
          _finDocBloc = BlocProvider.of<SalesInvoiceBloc>(context)
            ..add(FetchFinDoc(limit: limit));
        } else {
          tab = 0;
          _finDocBloc = BlocProvider.of<PurchInvoiceBloc>(context)
            ..add(FetchFinDoc(limit: limit));
        }
      }
      if (widget.docType == 'payment') {
        if (widget.sales) {
          tab = 0;
          _finDocBloc = BlocProvider.of<SalesPaymentBloc>(context)
            ..add(FetchFinDoc(limit: limit));
        } else {
          tab = 0;
          _finDocBloc = BlocProvider.of<PurchPaymentBloc>(context)
            ..add(FetchFinDoc(limit: limit));
        }
      }
    });
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) {
        authenticate = state?.authenticate;
        if (widget.docType == 'order') {
          if (widget.sales)
            return BlocConsumer<SalesFinDocBloc, FinDocState>(
                listener: (context, state) {
              if (state is FinDocProblem)
                HelperFunctions.showMessage(
                    context, '${state.errorMessage}', Colors.red);
              if (state is FinDocSuccess)
                HelperFunctions.showMessage(
                    context, '${state.message}', Colors.green);
            }, builder: (context, state) {
              if (state is FinDocSuccess)
                return finDocPage(state.finDocs, state.hasReachedMax);
              return Center(child: CircularProgressIndicator());
            });
          else
            return BlocConsumer<PurchFinDocBloc, FinDocState>(
                listener: (context, state) {
              if (state is FinDocProblem)
                HelperFunctions.showMessage(
                    context, '${state.errorMessage}', Colors.red);
              if (state is FinDocSuccess) {
                HelperFunctions.showMessage(
                    context, '${state.message}', Colors.green);
                HelperFunctions.showMessage(
                    context, '${state.errorMessage}', Colors.red);
              }
              if (state is FinDocLoading)
                HelperFunctions.showMessage(
                    context, '${state.message}', Colors.green);
            }, builder: (context, state) {
              List<FinDoc> finDocs = [];
              bool hasReachedMax = true;
              if (state is FinDocSuccess) {
                finDocs = state.finDocs;
                hasReachedMax = state.hasReachedMax;
              }
              if (state is FinDocLoading)
                return Center(child: CircularProgressIndicator());
              return finDocPage(finDocs, hasReachedMax);
            });
        }
        if (widget.docType == 'invoice') {
          if (widget.sales)
            return BlocConsumer<SalesInvoiceBloc, FinDocState>(
                listener: (context, state) {
              if (state is FinDocProblem)
                HelperFunctions.showMessage(
                    context, '${state.errorMessage}', Colors.red);
              if (state is FinDocSuccess)
                HelperFunctions.showMessage(
                    context, '${state.message}', Colors.green);
            }, builder: (context, state) {
              if (state is FinDocSuccess)
                return finDocPage(state.finDocs, state.hasReachedMax);
              return Center(child: CircularProgressIndicator());
            });
          else
            return BlocConsumer<PurchInvoiceBloc, FinDocState>(
                listener: (context, state) {
              if (state is FinDocProblem)
                HelperFunctions.showMessage(
                    context, '${state.errorMessage}', Colors.red);
              if (state is FinDocSuccess) {
                HelperFunctions.showMessage(
                    context, '${state.message}', Colors.green);
                HelperFunctions.showMessage(
                    context, '${state.errorMessage}', Colors.red);
              }
              if (state is FinDocLoading)
                HelperFunctions.showMessage(
                    context, '${state.message}', Colors.green);
            }, builder: (context, state) {
              List<FinDoc> finDocs = [];
              bool hasReachedMax = true;
              if (state is FinDocSuccess) {
                finDocs = state.finDocs;
                hasReachedMax = state.hasReachedMax;
              }
              if (state is FinDocLoading)
                return Center(child: CircularProgressIndicator());
              return finDocPage(finDocs, hasReachedMax);
            });
        }
        if (widget.docType == 'payment') {
          if (widget.sales)
            return BlocConsumer<SalesPaymentBloc, FinDocState>(
                listener: (context, state) {
              if (state is FinDocProblem)
                HelperFunctions.showMessage(
                    context, '${state.errorMessage}', Colors.red);
              if (state is FinDocSuccess)
                HelperFunctions.showMessage(
                    context, '${state.message}', Colors.green);
            }, builder: (context, state) {
              if (state is FinDocSuccess)
                return finDocPage(state.finDocs, state.hasReachedMax);
              return Center(child: CircularProgressIndicator());
            });
          else
            return BlocConsumer<PurchPaymentBloc, FinDocState>(
                listener: (context, state) {
              if (state is FinDocProblem)
                HelperFunctions.showMessage(
                    context, '${state.errorMessage}', Colors.red);
              if (state is FinDocSuccess) {
                HelperFunctions.showMessage(
                    context, '${state.message}', Colors.green);
                HelperFunctions.showMessage(
                    context, '${state.errorMessage}', Colors.red);
              }
              if (state is FinDocLoading)
                HelperFunctions.showMessage(
                    context, '${state.message}', Colors.green);
            }, builder: (context, state) {
              List<FinDoc> finDocs = [];
              bool hasReachedMax = true;
              if (state is FinDocSuccess) {
                finDocs = state.finDocs;
                hasReachedMax = state.hasReachedMax;
              }
              if (state is FinDocLoading)
                return Center(child: CircularProgressIndicator());
              return finDocPage(finDocs, hasReachedMax);
            });
        }
      }
      return Container(
          child: Center(
              child: Text("Not recognized document type: ${widget.docType}")));
    });
  }

  Widget finDocPage(finDocs, hasReachedMax) {
    return ListView.builder(
        itemCount: hasReachedMax && finDocs.isNotEmpty
            ? finDocs.length + 1
            : finDocs.length + 2,
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0)
            return ListTile(
                onTap: (() {
                  setState(() {
                    showSearchField = !showSearchField;
                  });
                }),
                leading: Image.asset('assets/images/search.png', height: 30),
                title: showSearchField
                    ? Row(children: <Widget>[
                        SizedBox(
                            width: ResponsiveWrapper.of(context)
                                    .isSmallerThan(TABLET)
                                ? MediaQuery.of(context).size.width - 250
                                : MediaQuery.of(context).size.width - 350,
                            child: TextField(
                              textInputAction: TextInputAction.go,
                              autofocus: true,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                hintText: "search in ID, " +
                                    (widget.sales ? "customer" : "supplier"),
                              ),
                              onChanged: ((value) {
                                searchString = value;
                              }),
                              onSubmitted: ((value) {
                                _finDocBloc.add(
                                    FetchFinDoc(search: value, limit: limit));
                                setState(() {
                                  showSearchField = !showSearchField;
                                });
                              }),
                            )),
                        ElevatedButton(
                            child: Text('Search'),
                            onPressed: () {
                              _finDocBloc.add(FetchFinDoc(
                                  search: searchString, limit: limit));
                            })
                      ])
                    : Column(children: [
                        Row(children: <Widget>[
                          Expanded(child: Text("${widget.docType} ID")),
                          Expanded(
                              child:
                                  Text(widget.sales ? "Customer" : "Supplier")),
                          if (!ResponsiveWrapper.of(context)
                              .isSmallerThan(TABLET))
                            Expanded(child: Text("Email")),
                          Expanded(child: Text("Date")),
                          if (!ResponsiveWrapper.of(context)
                              .isSmallerThan(TABLET))
                            Expanded(child: Text("Total")),
                          Expanded(
                              child:
                                  Text("Status", textAlign: TextAlign.center)),
                          if (!ResponsiveWrapper.of(context)
                              .isSmallerThan(TABLET))
                            Expanded(
                                child: Text("#items",
                                    textAlign: TextAlign.center)),
                        ]),
                        Divider(color: Colors.black),
                      ]),
                trailing: Text('                     '));
          if (index == 1 && finDocs.isEmpty)
            return Center(
                heightFactor: 20,
                child: Text("no records found!", textAlign: TextAlign.center));
          index -= 1;
          return index >= finDocs.length
              ? BottomLoader()
              : Dismissible(
                  key: Key(finDocs[index].orderId),
                  direction: DismissDirection.startToEnd,
                  child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Text("${finDocs[index].otherUser.lastName[0]}"),
                      ),
                      title: Row(
                        children: <Widget>[
                          Expanded(child: Text("${finDocs[index].orderId}")),
                          Expanded(
                              child:
                                  Text("${finDocs[index].otherUser.firstName}, "
                                      "${finDocs[index].otherUser.lastName}")),
                          if (!ResponsiveWrapper.of(context)
                              .isSmallerThan(TABLET))
                            Expanded(
                                child: Text(
                              "${finDocs[index].otherUser.email}",
                            )),
                          Expanded(
                              child: Text(
                            "${finDocs[index]?.creationDate?.toString()?.substring(0, 11)}",
                          )),
                          if (!ResponsiveWrapper.of(context)
                              .isSmallerThan(TABLET))
                            Expanded(
                                child: Text("${finDocs[index].grandTotal}",
                                    textAlign: TextAlign.center)),
                          Expanded(
                              child: Text(
                                  "${finDocStatusValues[finDocs[index].statusId]}",
                                  textAlign: TextAlign.center)),
                          if (!ResponsiveWrapper.of(context)
                              .isSmallerThan(TABLET))
                            Expanded(
                                child: Text("${finDocs[index].items?.length}",
                                    textAlign: TextAlign.center)),
                        ],
                      ),
                      onTap: () async {
                        await Navigator.pushNamed(context, '/order',
                            arguments: FormArguments(
                                menuIndex: tab, object: finDocs[index]));
                      },
                      trailing: Container(
                          width: 100,
                          child: Visibility(
                              visible:
                                  finDocStatusFixed[finDocs[index].statusId] ??
                                      true,
                              child: Row(children: [
                                IconButton(
                                  icon: Icon(Icons.delete_forever),
                                  tooltip: 'Cancel ${finDocs[0]?.docType}',
                                  onPressed: () {
                                    finDocs[index].statusId = 'finDocCancelled';
                                    _finDocBloc
                                        .add(UpdateFinDoc(finDocs[index]));
                                  },
                                ),
                                IconButton(
                                    icon: Icon(Icons.arrow_upward),
                                    tooltip: nextFinDocStatus[
                                        finDocStatusValues[
                                            finDocs[index].statusId]],
                                    onPressed: () {
                                      finDocs[index].statusId =
                                          nextFinDocStatus[
                                              finDocs[index].statusId];
                                      _finDocBloc
                                          .add(UpdateFinDoc(finDocs[index]));
                                    })
                              ])))));
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
      _finDocBloc.add(FetchFinDoc(limit: limit, search: searchString));
    }
  }
}
