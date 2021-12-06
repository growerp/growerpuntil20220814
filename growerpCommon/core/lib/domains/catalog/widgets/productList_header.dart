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

import 'package:core/domains/authenticate/blocs/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:core/domains/domains.dart';

class ProductListHeader extends StatelessWidget {
  const ProductListHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _searchController = TextEditingController();
    final productBloc = BlocProvider.of<ProductBloc>(context);
    late Authenticate authenticate;
    String classificationId = GlobalConfiguration().get("classificationId");
    String searchString = '';
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state.status == AuthStatus.authenticated)
        authenticate = state.authenticate!;
      return Material(
          child: ListTile(
              leading: GestureDetector(
                  key: Key('search'),
                  onTap: (() {
                    if (productBloc.state.search) {
                      productBloc.add(ProductSearchOff());
                      productBloc.add(ProductFetch(refresh: true));
                    } else
                      productBloc.add(ProductSearchOn());
                    productBloc.add(productBloc.state.search
                        ? ProductSearchOff()
                        : ProductSearchOn());
                  }),
                  child: Image.asset('assets/images/search.png', height: 30)),
              title: productBloc.state.search
                  ? Row(children: <Widget>[
                      Expanded(
                          child: TextField(
                        key: Key('searchField'),
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          hintText: "search in ID, name and description...",
                        ),
                        onChanged: ((value) {
                          searchString = value;
                        }),
                        onSubmitted: ((value) {
                          productBloc.add(ProductFetch(
                            companyPartyId: authenticate.company!.partyId!,
                            searchString: value,
                          ));
                        }),
                      )),
                      ElevatedButton(
                          key: Key('searchButton'),
                          child: Text('Search'),
                          onPressed: () {
                            productBloc.add(ProductFetch(
                                companyPartyId: authenticate.company!.partyId!,
                                searchString: searchString));
                            searchString = '';
                          })
                    ])
                  : Column(children: [
                      Row(children: <Widget>[
                        Expanded(
                            child: Text("Name", textAlign: TextAlign.center)),
                        if (!ResponsiveWrapper.of(context)
                            .isSmallerThan(TABLET))
                          Expanded(
                              child: Text("Description",
                                  textAlign: TextAlign.center)),
                        Expanded(
                            child: Text("Price", textAlign: TextAlign.center)),
                        if (classificationId != 'AppHotel')
                          Expanded(
                              child: Text("Catg", textAlign: TextAlign.center)),
                        Expanded(
                            child: Text(
                                classificationId != 'AppHotel'
                                    ? "Nbr Of Assets"
                                    : "Number of Rooms",
                                textAlign: TextAlign.center)),
                      ]),
                      Divider(color: Colors.black),
                    ]),
              trailing: Text(' ')));
    });
  }
}
