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
import 'package:core/blocs/@blocs.dart';
import 'package:core/widgets/@widgets.dart';
import 'package:core/helper_functions.dart';
import 'package:models/@models.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:core/forms/@forms.dart';

import '@forms.dart';

class OpportunitiesForm extends StatefulWidget {
  const OpportunitiesForm();
  @override
  _OpportunitiesState createState() => _OpportunitiesState();
}

class _OpportunitiesState extends State<OpportunitiesForm> {
  ScrollController _scrollController = ScrollController();
  double _scrollThreshold = 200.0;
  late OpportunityBloc _opportunityBloc;
  Authenticate? authenticate;
  int limit = 20;
  late bool searchField;
  String? searchString;
  bool? isLoading;

  @override
  void initState() {
    super.initState();
    searchField = false;
    _scrollController.addListener(_onScroll);
    _opportunityBloc = BlocProvider.of<OpportunityBloc>(context)
      ..add(FetchOpportunity());
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      limit = (MediaQuery.of(context).size.height / 35).round();
    });
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) {
        authenticate = state.authenticate;
        return BlocConsumer<OpportunityBloc, OpportunityState>(
            listener: (context, state) {
          if (state is OpportunityProblem)
            HelperFunctions.showMessage(
                context, '${state.errorMessage}', Colors.red);
          if (state is OpportunitySuccess) {
            HelperFunctions.showMessage(context, '${state.message}',
                state.error ? Colors.red : Colors.green);
          }
        }, builder: (context, state) {
          if (state is OpportunityLoading) return LoadingIndicator();
          if (state is OpportunityProblem)
            return FatalErrorForm("Could not load opportunities!");
          if (state is OpportunitySuccess) {
            isLoading = false;
            bool hasReachedMax = state.hasReachedMax ?? true;
            List<Opportunity>? opportunities = state.opportunities;
            return ListView.builder(
              itemCount: hasReachedMax && opportunities!.isNotEmpty
                  ? state.opportunities!.length + 1
                  : state.opportunities!.length + 2,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0)
                  return ListTile(
                      onTap: (() {
                        setState(() {
                          searchField = !searchField;
                        });
                      }),
                      leading:
                          Image.asset('assets/images/search.png', height: 30),
                      title: searchField
                          ? Row(children: <Widget>[
                              SizedBox(
                                  width: ResponsiveWrapper.of(context)
                                          .isSmallerThan(TABLET)
                                      ? MediaQuery.of(context).size.width - 250
                                      : MediaQuery.of(context).size.width - 350,
                                  child: TextField(
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      hintText:
                                          "search in ID, name and lead...",
                                    ),
                                    onChanged: ((value) {
                                      searchString = value;
                                    }),
                                    onSubmitted: ((value) {
                                      _opportunityBloc.add(FetchOpportunity(
                                          search: value, limit: limit));
                                      setState(() {
                                        searchField = !searchField;
                                      });
                                    }),
                                  )),
                              ElevatedButton(
                                  child: Text('Search'),
                                  onPressed: () {
                                    _opportunityBloc.add(FetchOpportunity(
                                        search: searchString, limit: limit));
                                    setState(() {
                                      searchField = !searchField;
                                    });
                                  })
                            ])
                          : Column(children: [
                              Row(children: <Widget>[
                                Expanded(
                                    child: Text(
                                  "Opportunity Name[ID]",
                                )),
                                if (!ResponsiveWrapper.of(context)
                                    .isSmallerThan(DESKTOP))
                                  Expanded(
                                      child: Text("Est. Amount",
                                          textAlign: TextAlign.center)),
                                if (!ResponsiveWrapper.of(context)
                                    .isSmallerThan(DESKTOP))
                                  Expanded(
                                      child: Text("Est. Probability %",
                                          textAlign: TextAlign.center)),
                                Expanded(
                                    child: Text("Lead Name[ID]",
                                        textAlign: TextAlign.right)),
                                if (!ResponsiveWrapper.of(context)
                                    .isSmallerThan(DESKTOP))
                                  Expanded(
                                      child: Text("Lead Email",
                                          textAlign: TextAlign.right)),
                                if (!ResponsiveWrapper.of(context)
                                    .isSmallerThan(TABLET))
                                  Expanded(
                                      child: Text("Stage",
                                          textAlign: TextAlign.center)),
                                if (!ResponsiveWrapper.of(context)
                                    .isSmallerThan(DESKTOP))
                                  Expanded(
                                      child: Text("Next Step",
                                          textAlign: TextAlign.center)),
                              ]),
                              Divider(color: Colors.black),
                            ]),
                      trailing: Text(' '));
                if (index == 1 && opportunities!.isEmpty)
                  return Center(
                      heightFactor: 20,
                      child: Text("no records found!",
                          textAlign: TextAlign.center));
                index -= 1;
                return index >= state.opportunities!.length
                    ? BottomLoader()
                    : Dismissible(
                        key: Key(state.opportunities![index].opportunityId!),
                        direction: DismissDirection.startToEnd,
                        child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Text(
                                  "${state.opportunities![index].opportunityName![0]}"),
                            ),
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                  "${opportunities![index].opportunityName}"
                                  "[${opportunities[index].opportunityId}]",
                                )),
                                if (!ResponsiveWrapper.of(context)
                                    .isSmallerThan(DESKTOP))
                                  Expanded(
                                      child: Text(
                                          "${opportunities[index].estAmount.toString()}",
                                          textAlign: TextAlign.center)),
                                if (!ResponsiveWrapper.of(context)
                                    .isSmallerThan(DESKTOP))
                                  Expanded(
                                      child: Text(
                                          "${opportunities[index].estProbability.toString()}",
                                          textAlign: TextAlign.center)),
                                Expanded(
                                    child: Text(
                                  (opportunities[index].leadPartyId != null
                                      ? "${opportunities[index].leadFirstName} "
                                          "${opportunities[index].leadLastName}"
                                          "[${opportunities[index].leadPartyId}]"
                                      : ""),
                                )),
                                if (!ResponsiveWrapper.of(context)
                                    .isSmallerThan(DESKTOP))
                                  Expanded(
                                      child: Text(
                                    opportunities[index].leadPartyId != null
                                        ? "${opportunities[index].leadEmail}"
                                        : "",
                                  )),
                                if (!ResponsiveWrapper.of(context)
                                    .isSmallerThan(TABLET))
                                  Text("${opportunities[index].stageId}",
                                      textAlign: TextAlign.center),
                                if (!ResponsiveWrapper.of(context)
                                    .isSmallerThan(DESKTOP))
                                  Expanded(
                                      child: Text(
                                          opportunities[index].nextStep != null
                                              ? "${opportunities[index].nextStep}"
                                              : "",
                                          textAlign: TextAlign.center)),
                              ],
                            ),
                            onTap: () async {
                              await showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return OpportunityDialog(
                                        formArguments: FormArguments(
                                            object: opportunities[index]));
                                  });
                            },
                            trailing: IconButton(
                              icon: Icon(Icons.delete_forever),
                              onPressed: () {
                                _opportunityBloc.add(DeleteOpportunity(index));
                              },
                            )));
              },
            );
          }
          isLoading = true;
          return Center(child: CircularProgressIndicator());
        });
      }
      return Container(child: Center(child: Text("Not Authorized!")));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _opportunityBloc
          .add(FetchOpportunity(limit: limit, search: searchString));
    }
  }
}
