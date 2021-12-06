// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Stats _$$_StatsFromJson(Map<String, dynamic> json) => _$_Stats(
      admins: json['admins'] as int? ?? 0,
      employees: json['employees'] as int? ?? 0,
      suppliers: json['suppliers'] as int? ?? 0,
      leads: json['leads'] as int? ?? 0,
      customers: json['customers'] as int? ?? 0,
      openSlsOrders: json['openSlsOrders'] as int? ?? 0,
      openPurOrders: json['openPurOrders'] as int? ?? 0,
      opportunities: json['opportunities'] as int? ?? 0,
      myOpportunities: json['myOpportunities'] as int? ?? 0,
      categories: json['categories'] as int? ?? 0,
      products: json['products'] as int? ?? 0,
      assets: json['assets'] as int? ?? 0,
      salesInvoicesNotPaidCount: json['salesInvoicesNotPaidCount'] as int? ?? 0,
      salesInvoicesNotPaidAmount: const DecimalConverter()
          .fromJson(json['salesInvoicesNotPaidAmount'] as String?),
      purchInvoicesNotPaidCount: json['purchInvoicesNotPaidCount'] as int? ?? 0,
      purchInvoicesNotPaidAmount: const DecimalConverter()
          .fromJson(json['purchInvoicesNotPaidAmount'] as String?),
      allTasks: json['allTasks'] as int? ?? 0,
      notInvoicedHours: json['notInvoicedHours'] as int? ?? 0,
      incomingShipments: json['incomingShipments'] as int? ?? 0,
      outgoingShipments: json['outgoingShipments'] as int? ?? 0,
      whLocations: json['whLocations'] as int? ?? 0,
    );

Map<String, dynamic> _$$_StatsToJson(_$_Stats instance) => <String, dynamic>{
      'admins': instance.admins,
      'employees': instance.employees,
      'suppliers': instance.suppliers,
      'leads': instance.leads,
      'customers': instance.customers,
      'openSlsOrders': instance.openSlsOrders,
      'openPurOrders': instance.openPurOrders,
      'opportunities': instance.opportunities,
      'myOpportunities': instance.myOpportunities,
      'categories': instance.categories,
      'products': instance.products,
      'assets': instance.assets,
      'salesInvoicesNotPaidCount': instance.salesInvoicesNotPaidCount,
      'salesInvoicesNotPaidAmount':
          const DecimalConverter().toJson(instance.salesInvoicesNotPaidAmount),
      'purchInvoicesNotPaidCount': instance.purchInvoicesNotPaidCount,
      'purchInvoicesNotPaidAmount':
          const DecimalConverter().toJson(instance.purchInvoicesNotPaidAmount),
      'allTasks': instance.allTasks,
      'notInvoicedHours': instance.notInvoicedHours,
      'incomingShipments': instance.incomingShipments,
      'outgoingShipments': instance.outgoingShipments,
      'whLocations': instance.whLocations,
    };
