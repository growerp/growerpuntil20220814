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

import 'package:core/domains/common/functions/functions.dart';
import 'package:core/domains/domains.dart';
import 'package:core/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import '../../../api_repository.dart';

class FinDocListForm extends StatelessWidget {
  const FinDocListForm({
    this.key,
    required this.sales,
    required this.docType,
    this.onlyRental = false,
    this.status,
    this.additionalItemButtonName,
    this.additionalItemButtonRoute,
  });

  final Key? key;
  final bool sales;
  final FinDocType docType;
  final bool onlyRental;
  final String? status;
  final String? additionalItemButtonName;
  final String? additionalItemButtonRoute;

  @override
  Widget build(BuildContext context) {
    Widget finDocList = FinDocList(
      key: key,
      sales: sales,
      docType: docType,
      onlyRental: onlyRental,
      status: status,
      additionalItemButtonName: additionalItemButtonName,
      additionalItemButtonRoute: additionalItemButtonRoute,
    );
    if (docType == FinDocType.order) {
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
    if (docType == FinDocType.invoice) {
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
    if (docType == FinDocType.payment) {
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
    if (docType == FinDocType.shipment) {
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
  const FinDocList({
    this.key,
    this.sales = true,
    this.docType = FinDocType.unknown,
    this.onlyRental = false,
    this.status,
    this.additionalItemButtonName,
    this.additionalItemButtonRoute,
  });

  final Key? key;
  final bool sales;
  final FinDocType docType;
  final bool onlyRental;
  final String? status;
  final String? additionalItemButtonName;
  final String? additionalItemButtonRoute;

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
  List<FinDoc> finDocs = <FinDoc>[];
  int? tab;
  int limit = 12;
  String classificationId = GlobalConfiguration().getValue("classificationId");
  late String entityName;
  bool isLoading = true;
  bool hasReachedMax = false;
  late FinDocBloc _finDocBloc;

  @override
  void initState() {
    super.initState();
    entityName =
        classificationId == 'AppHotel' && widget.docType == FinDocType.order
            ? 'Reservation'
            : widget.docType.toString();
    _scrollController.addListener(_onScroll);
    switch (widget.docType) {
      case FinDocType.order:
        widget.sales
            ? _finDocBloc = context.read<SalesOrderBloc>() as FinDocBloc
            : _finDocBloc = context.read<PurchaseOrderBloc>() as FinDocBloc;
        break;
      case FinDocType.invoice:
        widget.sales
            ? _finDocBloc = context.read<SalesInvoiceBloc>() as FinDocBloc
            : _finDocBloc = context.read<PurchaseInvoiceBloc>() as FinDocBloc;
        break;
      case FinDocType.payment:
        widget.sales
            ? _finDocBloc = context.read<SalesPaymentBloc>() as FinDocBloc
            : _finDocBloc = context.read<PurchasePaymentBloc>() as FinDocBloc;
        break;
      case FinDocType.shipment:
        widget.sales
            ? _finDocBloc = context.read<OutgoingShipmentBloc>() as FinDocBloc
            : _finDocBloc = context.read<IncomingShipmentBloc>() as FinDocBloc;
        break;
      case FinDocType.transaction:
        _finDocBloc = context.read<TransactionBloc>() as FinDocBloc;
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    limit = (MediaQuery.of(context).size.height / 60).round();
    Widget finDocsPage() {
      bool isPhone = ResponsiveWrapper.of(context).isSmallerThan(TABLET);
      return RefreshIndicator(
          onRefresh: (() async => _finDocBloc.add(FinDocFetch(refresh: true))),
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
                                "no (open)" +
                                    (widget.docType == FinDocType.shipment
                                        ? "${widget.sales ? 'outgoing' : 'incoming'} "
                                        : "${widget.sales ? 'sales' : 'purchase'} ") +
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
                          additionalItemButton: widget
                                          .additionalItemButtonName !=
                                      null &&
                                  widget.additionalItemButtonRoute != null
                              ? TextButton(
                                  key: Key('addButton$index'),
                                  child: Text(widget.additionalItemButtonName!),
                                  onPressed: () async {
                                    await Navigator.pushNamed(context,
                                        widget.additionalItemButtonRoute!,
                                        arguments: finDocs[index]);
                                  },
                                )
                              : null,
                        ));
              }));
    }

    return Builder(builder: (BuildContext context) {
      // used in the blocbuilder below

      dynamic listener = (context, state) {
        if (state.status == FinDocStatus.failure)
          HelperFunctions.showMessage(context, '${state.message}', Colors.red);
        if (state.status == FinDocStatus.success) {
          HelperFunctions.showMessage(
              context, '${state.message}', Colors.green);
        }
      };

      dynamic builder = (context, state) {
        if (state.status == FinDocStatus.success ||
            state.status == FinDocStatus.failure) {
          finDocs = state.finDocs;
          hasReachedMax = state.hasReachedMax;
          // if rental (hotelroom) need to show checkin/out orders
          if (widget.onlyRental && widget.status != null) {
            if (widget.status == FinDocStatusVal.Created) // = checkin
              finDocs = finDocs
                  .where((el) =>
                      el.items[0].rentalFromDate != null &&
                      el.status == widget.status &&
                      el.items[0].rentalFromDate!
                          .isSameDate(CustomizableDateTime.current))
                  .toList();
            if (widget.status == FinDocStatusVal.Approved) // = checkout
              finDocs = finDocs
                  .where((el) =>
                      el.items[0].rentalThruDate != null &&
                      el.status == widget.status &&
                      el.items[0].rentalThruDate!
                          .isSameDate(CustomizableDateTime.current))
                  .toList();
          } else if (widget.onlyRental == true) {
            finDocs = finDocs
                .where((el) => el.items[0].rentalFromDate != null)
                .toList();
          }

          return Scaffold(
              floatingActionButton: [
                FinDocType.order,
                FinDocType.invoice,
                FinDocType.payment,
              ].contains(widget.docType)
                  ? FloatingActionButton(
                      key: Key("addNew"),
                      onPressed: () async {
                        await showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (BuildContext context) {
                              return BlocProvider.value(
                                  value: _finDocBloc,
                                  child: widget.docType == FinDocType.payment
                                      ? PaymentDialog(FinDoc(
                                          sales: widget.sales,
                                          docType: widget.docType))
                                      : FinDocDialog(
                                          finDoc: FinDoc(
                                              sales: widget.sales,
                                              docType: widget.docType)));
                            });
                      },
                      tooltip: 'Add New',
                      child: Icon(Icons.add))
                  : null,
              body: finDocsPage());
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      };

      // finally create the Blocbuilder
      if (widget.docType == FinDocType.order) {
        if (widget.sales)
          return BlocConsumer<SalesOrderBloc, FinDocState>(
              listener: listener, builder: builder);
        return BlocConsumer<PurchaseOrderBloc, FinDocState>(
            listener: listener, builder: builder);
      }
      if (widget.docType == FinDocType.invoice) {
        if (widget.sales)
          return BlocConsumer<SalesInvoiceBloc, FinDocState>(
              listener: listener, builder: builder);
        return BlocConsumer<PurchaseInvoiceBloc, FinDocState>(
            listener: listener, builder: builder);
      }
      if (widget.docType == FinDocType.payment) {
        if (widget.sales)
          return BlocConsumer<SalesPaymentBloc, FinDocState>(
              listener: listener, builder: builder);
        return BlocConsumer<PurchasePaymentBloc, FinDocState>(
            listener: listener, builder: builder);
      }
      if (widget.docType == FinDocType.shipment) {
        if (widget.sales)
          return BlocConsumer<OutgoingShipmentBloc, FinDocState>(
              listener: listener, builder: builder);
        return BlocConsumer<IncomingShipmentBloc, FinDocState>(
            listener: listener, builder: builder);
      }
      return BlocConsumer<TransactionBloc, FinDocState>(
          listener: listener, builder: builder);
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
