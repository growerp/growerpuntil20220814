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

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:core/blocs/@blocs.dart';
import 'package:core/helper_functions.dart';
import 'package:core/widgets/@widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';

class OpportunityForm extends StatelessWidget {
  final FormArguments formArguments;
  OpportunityForm(this.formArguments);

  @override
  Widget build(BuildContext context) {
    var a = (formArguments) =>
        (OpportunityPage(formArguments.message, formArguments.object));
    return ShowNavigationRail(a(formArguments), 2);
  }
}

class OpportunityPage extends StatefulWidget {
  final String message;
  final Opportunity opportunity;
  OpportunityPage(this.message, this.opportunity);
  @override
  _OpportunityState createState() => _OpportunityState(message, opportunity);
}

class _OpportunityState extends State<OpportunityPage> {
  final String message;
  final Opportunity opportunity;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _estAmountController = TextEditingController();
  final _estProbabilityController = TextEditingController();
  final _estNextStepController = TextEditingController();
  Opportunity updatedOpportunity;
  bool loading = false;
  String _selectedStage;
  User _selectedAccount;
  User _selectedLead;
  List<User> leads;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  _OpportunityState(this.message, this.opportunity) {
    HelperFunctions.showTopMessage(scaffoldMessengerKey, message);
  }

  @override
  Widget build(BuildContext context) {
    Authenticate authenticate;
    Opportunity opportunity;
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) authenticate = state.authenticate;
      return ScaffoldMessenger(
          key: scaffoldMessengerKey,
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading:
                    ResponsiveWrapper.of(context).isSmallerThan(TABLET),
                title: companyLogo(context, authenticate, 'Opportunity detail'),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.home),
                      onPressed: () => Navigator.pushNamed(context, 'home',
                          arguments: FormArguments()))
                ],
              ),
              drawer: myDrawer(context, authenticate),
              body: BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthProblem)
                      HelperFunctions.showMessage(
                          context, '${state.errorMessage}', Colors.red);
                  },
                  child: BlocConsumer<OpportunityBloc, OpportunityState>(
                      listener: (context, state) {
                    if (state is OpportunityProblem) {
                      loading = false;
                      HelperFunctions.showMessage(
                          context, '${state.errorMessage}', Colors.red);
                    }
                    if (state is OpportunitySuccess)
                      Navigator.of(context).pop(updatedOpportunity);
                  }, builder: (context, state) {
                    if (state is OpportunitySuccess) {
                      opportunity = state.opportunity;
                      leads = state.leads;
                    }
                    return Center(
                      child: _showForm(
                          updatedOpportunity, opportunity, authenticate),
                    );
                  }))));
    });
  }

  Widget _showForm(Opportunity updatedOpportunity, Opportunity opportunity,
      Authenticate authenticate) {
    _nameController..text = opportunity?.opportunityName;
    _descriptionController..text = opportunity?.description;
    _estAmountController..text = opportunity?.estAmount?.toString();
    _estProbabilityController..text = opportunity?.estProbability?.toString();
    _estNextStepController..text = opportunity?.nextStep?.toString();
    if (_selectedLead == null && opportunity?.leadPartyId != null)
      _selectedLead =
          User(partyId: opportunity?.leadPartyId, email: opportunity?.email);
    if (_selectedAccount != null && opportunity?.accountPartyId != null)
      _selectedAccount = authenticate.company.employees
          .firstWhere((x) => x.partyId == opportunity?.accountPartyId);
    _selectedStage = opportunity?.stageId ?? opportunityStages[0];
    int columns = ResponsiveWrapper.of(context).isSmallerThan(TABLET) ? 1 : 2;
    return Center(
        child: Container(
            width: columns.toDouble() * 400,
            child: Form(
                key: _formKey,
                child: Padding(
                    padding: EdgeInsets.all(15),
                    child: GridView.count(
                        crossAxisCount: columns,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: (7),
                        children: <Widget>[
                          TextFormField(
                            key: Key('name'),
                            decoration:
                                InputDecoration(labelText: 'Opportunity Name'),
                            controller: _nameController,
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Please enter a opportunity name?';
                              return null;
                            },
                          ),
                          TextFormField(
                            key: Key('description'),
                            decoration:
                                InputDecoration(labelText: 'Description'),
                            controller: _descriptionController,
                          ),
                          TextFormField(
                            key: Key('EstAmount'),
                            decoration:
                                InputDecoration(labelText: 'Expected Amount'),
                            controller: _estAmountController,
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Please enter an amount?';
                              return null;
                            },
                          ),
                          TextFormField(
                            key: Key('EstProb'),
                            decoration: InputDecoration(
                                labelText: 'Estimated Probabilty'),
                            controller: _estProbabilityController,
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Please enter a probability % ?';
                              return null;
                            },
                          ),
                          TextFormField(
                            key: Key('NextStep'),
                            decoration: InputDecoration(labelText: 'Next step'),
                            controller: _estNextStepController,
                            validator: (value) {
                              if (value.isEmpty) return 'Next step?';
                              return null;
                            },
                          ),
                          DropdownButtonFormField<String>(
                            key: Key('dropDownStage'),
                            hint: Text('Opportunity Stage'),
                            value: _selectedStage,
                            validator: (value) =>
                                value == null ? 'field required' : null,
                            items: opportunityStages.map((item) {
                              return DropdownMenuItem<String>(
                                  child: Text(item), value: item);
                            })?.toList(),
                            onChanged: (String newValue) {
                              setState(() {
                                _selectedStage = newValue;
                              });
                            },
                            isExpanded: true,
                          ),
                          DropdownButtonFormField<User>(
                            key: Key('dropDownLead'),
                            hint: Text('Lead'),
                            value: _selectedLead,
//                            validator: (value) =>
//                                value == null ? 'field required' : null,
                            items: leads?.map((item) {
                              return DropdownMenuItem<User>(
                                  child: Text(
                                      "${item.firstName} ${item.lastName}"),
                                  value: item);
                            })?.toList(),
                            onChanged: (User newValue) {
                              setState(() {
                                _selectedLead = newValue;
                              });
                            },
                            isExpanded: true,
                          ),
                          DropdownButtonFormField<User>(
                            key: Key('dropDownAccount'),
                            hint: Text('Account'),
                            value: _selectedAccount,
                            items: authenticate.company.employees.map((item) {
                              return DropdownMenuItem<User>(
                                  child: Text(
                                      "${item.firstName} ${item.lastName}"),
                                  value: item);
                            })?.toList(),
                            onChanged: (User newValue) {
                              setState(() {
                                _selectedAccount = newValue;
                              });
                            },
                            isExpanded: true,
                          ),
                          RaisedButton(
                              key: Key('update'),
                              child: Text(opportunity?.opportunityId == null
                                  ? 'Create'
                                  : 'Update'),
                              onPressed: () {
                                if (_formKey.currentState.validate() &&
                                    !loading) {
                                  updatedOpportunity = Opportunity(
                                    opportunityId: opportunity?.opportunityId,
                                    opportunityName: _nameController.text,
                                    description: _descriptionController.text,
                                    estAmount: Decimal.parse(
                                        _estAmountController.text),
                                    estProbability: int.parse(
                                        _estProbabilityController.text),
                                    stageId: _selectedStage,
                                    nextStep: _estNextStepController.text,
                                    accountPartyId: _selectedAccount?.partyId,
                                    leadPartyId: _selectedLead?.partyId,
                                  );
                                  BlocProvider.of<OpportunityBloc>(context)
                                      .add(UpdateOpportunity(
                                    updatedOpportunity,
                                  ));
                                }
                              }),
                          RaisedButton(
                              key: Key('cancel'),
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })
                        ])))));
  }
}
