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

part of 'finDoc_bloc.dart';

enum FinDocStatus { initial, loading, success, failure }

class FinDocState extends Equatable {
  const FinDocState({
    this.status = FinDocStatus.initial,
    this.finDocs = const [],
    this.paymentTypes = const [],
    this.itemTypes = const [],
    this.users = const [],
    this.message,
    this.hasReachedMax = false,
    this.searchString = '',
  });

  final FinDocStatus status;
  final String? message;
  final List<FinDoc> finDocs;
  final List<PaymentType> paymentTypes;
  final List<ItemType> itemTypes;
  final List<User> users;
  final bool hasReachedMax;
  final String searchString;

  FinDocState copyWith({
    FinDocStatus? status,
    String? message,
    List<FinDoc>? finDocs,
    List<ItemType>? itemTypes,
    List<User>? users,
    List<PaymentType>? paymentTypes,
    bool? hasReachedMax,
    String? searchString,
  }) {
    return FinDocState(
      status: status ?? this.status,
      finDocs: finDocs ?? this.finDocs,
      itemTypes: itemTypes ?? this.itemTypes,
      paymentTypes: paymentTypes ?? this.paymentTypes,
      users: users ?? this.users,
      message: message,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchString: searchString ?? this.searchString,
    );
  }

  @override
  List<Object?> get props =>
      [status, message, finDocs, itemTypes, paymentTypes, users];

  @override
  String toString() => '$status { #finDocs: ${finDocs.length}, '
      'hasReachedMax: $hasReachedMax message $message}';
}
