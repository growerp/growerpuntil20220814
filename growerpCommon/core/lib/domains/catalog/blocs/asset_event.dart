part of 'asset_bloc.dart';

abstract class AssetEvent extends Equatable {
  const AssetEvent();
  @override
  List<Object> get props => [];
}

class AssetFetch extends AssetEvent {
  const AssetFetch({this.searchString = '', this.refresh = false});
  final String searchString;
  final bool refresh;
  @override
  List<Object> get props => [searchString, refresh];
}

class AssetSearchOn extends AssetEvent {}

class AssetSearchOff extends AssetEvent {}

class AssetDelete extends AssetEvent {
  const AssetDelete(this.asset);
  final Asset asset;
}

class AssetUpdate extends AssetEvent {
  const AssetUpdate(this.asset);
  final Asset asset;
}
