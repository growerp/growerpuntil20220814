part of 'asset_bloc.dart';

enum AssetStatus { initial, success, failure }

class AssetState extends Equatable {
  const AssetState({
    this.status = AssetStatus.initial,
    this.assets = const <Asset>[],
    this.message,
    this.hasReachedMax = false,
    this.searchString = '',
    this.search = false,
  });

  final AssetStatus status;
  final String? message;
  final List<Asset> assets;
  final bool hasReachedMax;
  final String searchString;
  final bool search;

  AssetState copyWith({
    AssetStatus? status,
    String? message,
    List<Asset>? assets,
    bool error = false,
    bool? hasReachedMax,
    String? searchString,
    bool? search,
  }) {
    return AssetState(
      status: status ?? this.status,
      assets: assets ?? this.assets,
      message: message ?? this.message,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchString: searchString ?? this.searchString,
      search: search ?? this.search,
    );
  }

  @override
  List<Object?> get props => [assets, hasReachedMax, search];

  @override
  String toString() => '$status { #assets: ${assets.length}, '
      'hasReachedMax: $hasReachedMax message $message}';
}
