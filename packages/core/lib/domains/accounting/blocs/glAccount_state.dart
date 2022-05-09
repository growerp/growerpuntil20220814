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

part of 'glAccount_bloc.dart';

enum GlAccountStatus { initial, success, failure }

class GlAccountState extends Equatable {
  const GlAccountState({
    this.status = GlAccountStatus.initial,
    this.glAccounts = const <GlAccount>[],
    this.message,
    this.hasReachedMax = false,
    this.searchString = '',
  });

  final GlAccountStatus status;
  final String? message;
  final List<GlAccount> glAccounts;
  final bool hasReachedMax;
  final String searchString;

  GlAccountState copyWith({
    GlAccountStatus? status,
    String? message,
    List<GlAccount>? glAccounts,
    bool error = false,
    bool? hasReachedMax,
    String? searchString,
    bool? search,
  }) {
    return GlAccountState(
      status: status ?? this.status,
      glAccounts: glAccounts ?? this.glAccounts,
      message: message,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchString: searchString ?? this.searchString,
    );
  }

  @override
  List<Object?> get props => [glAccounts, hasReachedMax];

  @override
  String toString() => '$status { #glAccounts: ${glAccounts.length}, '
      'hasReachedMax: $hasReachedMax message $message}';
}
