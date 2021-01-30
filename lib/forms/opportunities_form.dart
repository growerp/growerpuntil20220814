import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/blocs/@blocs.dart';
import 'package:core/widgets/@widgets.dart';
import 'package:core/helper_functions.dart';
import 'package:models/@models.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class OpportunitiesForm extends StatefulWidget {
  const OpportunitiesForm();
  @override
  _OpportunitiesState createState() => _OpportunitiesState();
}

class _OpportunitiesState extends State<OpportunitiesForm> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  OpportunityBloc _opportunityBloc;
  Authenticate authenticate;
  int limit = 20;
  bool search;
  String searchString;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _opportunityBloc = BlocProvider.of<OpportunityBloc>(context)
      ..add(FetchOpportunity(limit: limit));
    search = false;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      limit = (MediaQuery.of(context).size.height / 35).round();
    });
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) {
        authenticate = state?.authenticate;
        return BlocConsumer<OpportunityBloc, OpportunityState>(
            listener: (context, state) {
          if (state is OpportunityProblem)
            HelperFunctions.showMessage(
                context, '${state.errorMessage}', Colors.red);
          if (state is OpportunitySuccess)
            HelperFunctions.showMessage(
                context, '${state.message}', Colors.green);
        }, builder: (context, state) {
          if (state is OpportunitySuccess) {
            List<Opportunity> opportunities = state.opportunities;
            return ListView.builder(
              itemCount: state.hasReachedMax && opportunities.isNotEmpty
                  ? state.opportunities.length + 1
                  : state.opportunities.length + 2,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0)
                  return ListTile(
                      onTap: (() {
                        setState(() {
                          search = !search;
                        });
                      }),
                      leading:
                          Image.asset('assets/images/search.png', height: 30),
                      title: search
                          ? Row(children: <Widget>[
                              SizedBox(
                                  width: ResponsiveWrapper.of(context)
                                          .isSmallerThan(TABLET)
                                      ? MediaQuery.of(context).size.width - 200
                                      : MediaQuery.of(context).size.width - 350,
                                  child: TextField(
                                    textInputAction: TextInputAction.go,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      hintText:
                                          "search in ID, name and description...",
                                    ),
                                    onTap: (() {
                                      setState(() {
                                        search = !search;
                                      });
                                    }),
                                    onChanged: ((value) {
                                      searchString = value;
                                    }),
                                    onSubmitted: ((value) {
                                      _opportunityBloc.add(FetchOpportunity(
                                          search: value, limit: limit));
                                      setState(() {
                                        search = !search;
                                      });
                                    }),
                                  )),
                              RaisedButton(
                                  child: Text('Search'),
                                  onPressed: () {
                                    _opportunityBloc.add(FetchOpportunity(
                                        search: searchString, limit: limit));
                                  })
                            ])
                          : Column(children: [
                              Row(children: <Widget>[
                                Expanded(
                                    child: Text("Opportunity.Name[ID]",
                                        textAlign: TextAlign.center)),
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
                                    child: Text("Lead Name",
                                        textAlign: TextAlign.center)),
                                if (!ResponsiveWrapper.of(context)
                                    .isSmallerThan(DESKTOP))
                                  Expanded(
                                      child: Text("Lead Email",
                                          textAlign: TextAlign.center)),
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
                if (index == 1 && opportunities.isEmpty)
                  return Center(
                      heightFactor: 20,
                      child: Text("no records found!",
                          textAlign: TextAlign.center));
                index -= 1;
                return index >= state.opportunities.length
                    ? BottomLoader()
                    : Dismissible(
                        key: Key(state.opportunities[index].opportunityId),
                        direction: DismissDirection.startToEnd,
                        child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Text(
                                  "${state.opportunities[index]?.opportunityName[0]}"),
                            ),
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                        "${opportunities[index].opportunityName}"
                                        "[${opportunities[index].opportunityId}]",
                                        textAlign: TextAlign.center)),
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
                                        opportunities[index].leadPartyId != null
                                            ? "${opportunities[index].leadFirstName} "
                                                "${opportunities[index].leadLastName}"
                                            : "",
                                        textAlign: TextAlign.center)),
                                if (!ResponsiveWrapper.of(context)
                                    .isSmallerThan(DESKTOP))
                                  Expanded(
                                      child: Text(
                                          opportunities[index].leadPartyId !=
                                                  null
                                              ? "${opportunities[index].leadEmail}"
                                              : "",
                                          textAlign: TextAlign.center)),
                                if (!ResponsiveWrapper.of(context)
                                    .isSmallerThan(TABLET))
                                  Text("${opportunities[index].stageId}",
                                      textAlign: TextAlign.center),
                                if (!ResponsiveWrapper.of(context)
                                    .isSmallerThan(DESKTOP))
                                  Expanded(
                                      child: Text(
                                          "${opportunities[index].nextStep}",
                                          textAlign: TextAlign.center)),
                              ],
                            ),
                            onTap: () async {
                              await Navigator.pushNamed(context, '/opportunity',
                                  arguments: FormArguments(
                                      null, 0, state.opportunities[index]));
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
