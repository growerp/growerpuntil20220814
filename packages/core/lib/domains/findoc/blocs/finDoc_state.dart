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
    this.finDocs = const <FinDoc>[],
    this.message,
    this.hasReachedMax = false,
    this.searchString = '',
    this.search = false,
  });

  final FinDocStatus status;
  final String? message;
  final List<FinDoc> finDocs;
  final bool hasReachedMax;
  final String searchString;
  final bool search;

  FinDocState copyWith({
    FinDocStatus? status,
    String? message,
    List<FinDoc>? finDocs,
    bool? hasReachedMax,
    String? searchString,
    bool? search,
  }) {
    return FinDocState(
      status: status ?? this.status,
      finDocs: finDocs ?? this.finDocs,
      message: message,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchString: searchString ?? this.searchString,
      search: search ?? this.search,
    );
  }

  @override
  List<Object?> get props => [status, finDocs, hasReachedMax, search];

  @override
  String toString() => '$status { #finDocs: ${finDocs.length}, '
      'hasReachedMax: $hasReachedMax message $message}';
}
