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

import 'package:core/domains/domains.dart';
import 'package:core/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import '../../../api_repository.dart';

class FinDocListForm extends StatelessWidget {
  final Key? key;
  final bool sales;
  final FinDocType docType;
  final bool onlyRental;
  final String? statusId;
  const FinDocListForm(
      {this.key,
      required this.sales,
      required this.docType,
      this.onlyRental = false,
      this.statusId});

  @override
  Widget build(BuildContext context) {
    Widget finDocList = FinDocList(
      key: key,
      sales: sales,
      docType: docType,
      onlyRental: onlyRental,
      statusId: statusId,
    );
    if (docType == FinDocType.Order) {
      if (sales)
        return BlocProvider<SalesOrderBloc>(
            create: (context) =>
                FinDocBloc(context.read<APIRepository>(), sales, docType)
                  ..add(FinDocFetch()),
            child: finDocList);
      return BlocProvider<PurchaseOrderBloc>(
          create: (BuildContext context) =>
              FinDocBloc(context.read<APIRepository>(), sales, docType)
                ..add(FinDocFetch()),
          child: finDocList);
    }
    if (docType == FinDocType.Invoice) {
      if (sales)
        return BlocProvider<SalesInvoiceBloc>(
            create: (context) =>
                FinDocBloc(context.read<APIRepository>(), sales, docType)
                  ..add(FinDocFetch()),
            child: finDocList);
      return BlocProvider<PurchaseInvoiceBloc>(
          create: (BuildContext context) =>
              FinDocBloc(context.read<APIRepository>(), sales, docType)
                ..add(FinDocFetch()),
          child: finDocList);
    }
    if (docType == FinDocType.Payment) {
      if (sales)
        return BlocProvider<SalesPaymentBloc>(
            create: (context) =>
                FinDocBloc(context.read<APIRepository>(), sales, docType)
                  ..add(FinDocFetch()),
            child: finDocList);
      return BlocProvider<PurchasePaymentBloc>(
          create: (BuildContext context) =>
              FinDocBloc(context.read<APIRepository>(), sales, docType)
                ..add(FinDocFetch()),
          child: finDocList);
    }
    if (docType == FinDocType.Shipment) {
      if (sales)
        return BlocProvider<OutgoingShipmentBloc>(
            create: (context) =>
                FinDocBloc(context.read<APIRepository>(), sales, docType)
                  ..add(FinDocFetch()),
            child: finDocList);
      return BlocProvider<IncomingShipmentBloc>(
          create: (BuildContext context) =>
              FinDocBloc(context.read<APIRepository>(), sales, docType)
                ..add(FinDocFetch()),
          child: finDocList);
    }
    return BlocProvider<TransactionBloc>(
        create: (context) =>
            FinDocBloc(context.read<APIRepository>(), sales, docType)
              ..add(FinDocFetch()),
        child: finDocList);
  }
}

class FinDocList extends StatefulWidget {
  final Key? key;
  final bool sales;
  final FinDocType docType;
  final bool onlyRental;
  final String? statusId;
  const FinDocList({
    this.key,
    this.sales = true,
    this.docType = FinDocType.Unknown,
    this.onlyRental = false,
    this.statusId,
  });
  @override
  FinDocListState createState() => FinDocListState();
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class FinDocListState extends State<FinDocList> {
  final _scrollController = ScrollController();
  List<FinDoc> finDocsAll = <FinDoc>[];
  List<FinDoc> finDocs = <FinDoc>[];
  int? tab;
  int limit = 12;
  late bool search;
  String classificationId = GlobalConfiguration().getValue("classificationId");
  late String entityName;
  bool isLoading = true;
  bool hasReachedMax = false;
  late FinDocBloc _finDocBloc;

  @override
  void initState() {
    super.initState();
    search = false;
    entityName =
        classificationId == 'AppHotel' && widget.docType == FinDocType.Order
            ? 'Reservation'
            : widget.docType.toString();
    _scrollController.addListener(_onScroll);
    switch (widget.docType) {
      case FinDocType.Order:
        widget.sales
            ? _finDocBloc =
                BlocProvider.of<SalesOrderBloc>(context) as FinDocBloc
            : _finDocBloc =
                BlocProvider.of<PurchaseOrderBloc>(context) as FinDocBloc;
        break;
      case FinDocType.Invoice:
        widget.sales
            ? _finDocBloc =
                BlocProvider.of<SalesInvoiceBloc>(context) as FinDocBloc
            : _finDocBloc =
                BlocProvider.of<PurchaseInvoiceBloc>(context) as FinDocBloc;
        break;
      case FinDocType.Payment:
        widget.sales
            ? _finDocBloc =
                BlocProvider.of<SalesPaymentBloc>(context) as FinDocBloc
            : _finDocBloc =
                BlocProvider.of<PurchasePaymentBloc>(context) as FinDocBloc;
        break;
      case FinDocType.Shipment:
        widget.sales
            ? _finDocBloc =
                BlocProvider.of<OutgoingShipmentBloc>(context) as FinDocBloc
            : _finDocBloc =
                BlocProvider.of<IncomingShipmentBloc>(context) as FinDocBloc;
        break;
      case FinDocType.Transaction:
        _finDocBloc = BlocProvider.of<TransactionBloc>(context) as FinDocBloc;
    }
  }

  @override
  Widget build(BuildContext context) {
    limit = (MediaQuery.of(context).size.height / 60).round();
    // used as a child if the blocBuilder
    Widget finDocsPage() {
      bool isPhone = ResponsiveWrapper.of(context).isSmallerThan(TABLET);
      return RefreshIndicator(
          onRefresh: (() async {
            _finDocBloc.add(FinDocFetch(refresh: true));
          }),
          child: ListView.builder(
              key: Key('listView'),
              physics: AlwaysScrollableScrollPhysics(),
              itemCount:
                  hasReachedMax ? finDocs.length + 1 : finDocs.length + 2,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0)
                  return Column(children: [
                    FinDocListHeader(
                        isPhone: isPhone,
                        sales: widget.sales,
                        docType: widget.docType,
                        finDocBloc: _finDocBloc),
                    Divider(color: Colors.black),
                    Visibility(
                        visible: finDocs.isEmpty,
                        child: Center(
                            heightFactor: 20,
                            child: Text(
                                (widget.docType == FinDocType.Shipment
                                        ? "no open ${widget.sales ? 'outgoing' : 'incoming'} "
                                        : "no ${widget.sales ? 'sales' : 'purchase'} ") +
                                    "${entityName}s found!",
                                textAlign: TextAlign.center)))
                  ]);
                index--;
                return index >= finDocs.length
                    ? BottomLoader()
                    : Dismissible(
                        key: Key('finDocItem'),
                        direction: DismissDirection.startToEnd,
                        child: FinDocListItem(
                          finDoc: finDocs[index],
                          docType: widget.docType,
                          index: index,
                          isPhone: isPhone,
                          sales: widget.sales,
                          onlyRental: widget.onlyRental,
                          finDocBloc: _finDocBloc,
                        ));
              }));
    }

    return Builder(builder: (BuildContext context) {
      // used in the blocbuilder below
      dynamic builder = (context, state) {
        switch (state.status) {
          case FinDocStatus.failure:
            return Center(child: Text('failed to fetch documents'));
          case FinDocStatus.success:
            search = state.search;
            finDocsAll = state.finDocs;
            // if rental (hotelroom) need to show checkin/out orders
            if (widget.onlyRental && widget.statusId != null) {
              if (widget.statusId == 'FinDocCreated') // = checkin
                finDocs = finDocsAll
                    .where((el) =>
                        el.items[0].rentalFromDate != null &&
                        el.statusId == widget.statusId &&
                        el.items[0].rentalFromDate!
                            .isSameDate(CustomizableDateTime.current))
                    .toList();
              if (widget.statusId == 'FinDocApproved') // = checkout
                finDocs = finDocsAll
                    .where((el) =>
                        el.items[0].rentalThruDate != null &&
                        el.statusId == widget.statusId &&
                        el.items[0].rentalThruDate!
                            .isSameDate(CustomizableDateTime.current))
                    .toList();
            } else if (widget.onlyRental == true) {
              finDocs = finDocsAll
                  .where((el) => el.items[0].rentalFromDate != null)
                  .toList();
            } else
              finDocs = finDocsAll;
            hasReachedMax = state.hasReachedMax;

            return Scaffold(
                floatingActionButton: widget.docType == FinDocType.Order
                    ? FloatingActionButton(
                        key: Key("addNew"),
                        onPressed: () async {
                          await showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return BlocProvider.value(
                                    value: _finDocBloc,
                                    child: FinDocDialog(
                                        finDoc: FinDoc(
                                            sales: widget.sales,
                                            docType: widget.docType)));
                              });
                        },
                        tooltip: 'Add New',
                        child: Icon(Icons.add))
                    : null,
                body: finDocsPage());
          default:
            return const Center(child: CircularProgressIndicator());
        }
      };

      // finally create the Blocbuilder
      if (widget.docType == FinDocType.Order) {
        if (widget.sales)
          return BlocBuilder<SalesOrderBloc, FinDocState>(builder: builder);
        return BlocBuilder<PurchaseOrderBloc, FinDocState>(builder: builder);
      }
      if (widget.docType == FinDocType.Invoice) {
        if (widget.sales)
          return BlocBuilder<SalesInvoiceBloc, FinDocState>(builder: builder);
        return BlocBuilder<PurchaseInvoiceBloc, FinDocState>(builder: builder);
      }
      if (widget.docType == FinDocType.Payment) {
        if (widget.sales)
          return BlocBuilder<SalesPaymentBloc, FinDocState>(builder: builder);
        return BlocBuilder<PurchasePaymentBloc, FinDocState>(builder: builder);
      }
      if (widget.docType == FinDocType.Shipment) {
        if (widget.sales)
          return BlocBuilder<OutgoingShipmentBloc, FinDocState>(
              builder: builder);
        return BlocBuilder<IncomingShipmentBloc, FinDocState>(builder: builder);
      }
      return BlocBuilder<TransactionBloc, FinDocState>(builder: builder);
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) _finDocBloc.add(FinDocFetch());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
