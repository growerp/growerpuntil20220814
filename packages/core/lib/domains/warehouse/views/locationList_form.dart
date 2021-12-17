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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domains/domains.dart';

import '../../../api_repository.dart';

class LocationListForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          LocationBloc(context.read<APIRepository>())..add(LocationFetch()),
      child: LocationList(),
    );
  }
}

class LocationList extends StatefulWidget {
  @override
  _LocationsState createState() => _LocationsState();
}

class _LocationsState extends State<LocationList> {
  final _scrollController = ScrollController();
  late LocationBloc _locationBloc;
  Authenticate authenticate = Authenticate();
  int limit = 20;
  late bool search;
  String? searchString;

  @override
  void initState() {
    super.initState();
    _locationBloc = BlocProvider.of<LocationBloc>(context);
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        switch (state.status) {
          case LocationStatus.failure:
            return Center(
                child: Text('failed to fetch locations: ${state.message}'));
          case LocationStatus.success:
            search = state.search;
            return Scaffold(
                floatingActionButton: FloatingActionButton(
                    key: Key("addNew"),
                    onPressed: () async {
                      await showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            return BlocProvider.value(
                                value: _locationBloc,
                                child: LocationDialog(Location()));
                          });
                    },
                    tooltip: 'Add New',
                    child: Icon(Icons.add)),
                body: RefreshIndicator(
                    onRefresh: (() async {
                      _locationBloc.add(LocationFetch(refresh: true));
                    }),
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: state.hasReachedMax
                          ? state.locations.length + 1
                          : state.locations.length + 2,
                      controller: _scrollController,
                      itemBuilder: (BuildContext context, int index) {
                        if (state.locations.isEmpty)
                          return Center(
                              heightFactor: 20,
                              child: Text("no locations found!",
                                  key: Key('empty'),
                                  textAlign: TextAlign.center));
                        if (index == 0)
                          return LocationListHeader(search: search);
                        index--;
                        return index >= state.locations.length
                            ? BottomLoader()
                            : Dismissible(
                                key: Key('locationItem'),
                                direction: DismissDirection.startToEnd,
                                child: LocationListItem(
                                    location: state.locations[index],
                                    index: index));
                      },
                    )));
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<LocationBloc>().add(LocationFetch());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
