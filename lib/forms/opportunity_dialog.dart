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
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/@models.dart';
import 'package:core/blocs/@blocs.dart';
import 'package:core/helper_functions.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:dropdown_search/dropdown_search.dart';

class OpportunityDialog extends StatelessWidget {
  final FormArguments formArguments;
  const OpportunityDialog({Key? key, required this.formArguments})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpportunityPage(
        formArguments.message, formArguments.object as Opportunity);
  }
}

class OpportunityPage extends StatefulWidget {
  final String? message;
  final Opportunity? opportunity;
  const OpportunityPage(this.message, this.opportunity);
  @override
  _OpportunityState createState() => _OpportunityState();
}

class _OpportunityState extends State<OpportunityPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _estAmountController = TextEditingController();
  final _estProbabilityController = TextEditingController();
  final _estNextStepController = TextEditingController();
  final _leadSearchBoxController = TextEditingController();
  final _accountSearchBoxController = TextEditingController();

  late Opportunity opportunity;
  bool loading = false;
  String? _selectedStageId;
  User? _selectedAccount;
  User? _selectedLead;

  @override
  void initState() {
    super.initState();
    opportunity = widget.opportunity ?? Opportunity();
  }

  @override
  Widget build(BuildContext context) {
    var repos = context.read<Object>();
    return BlocConsumer<OpportunityBloc, OpportunityState>(
        listener: (context, state) {
      if (state is OpportunityProblem) {
        loading = false;
        HelperFunctions.showMessage(
            context, '${state.errorMessage}', Colors.red);
      }
      if (state is OpportunityLoading)
        HelperFunctions.showMessage(context, '${state.message}', Colors.green);
      if (state is OpportunitySuccess) Navigator.of(context).pop();
    }, builder: (context, state) {
      if (state is OpportunityLoading) return Container();
      return Center(
        child: _showForm(repos),
      );
    });
  }

  Widget _showForm(repos) {
    _nameController..text = opportunity.opportunityName ?? '';
    _descriptionController..text = opportunity.description ?? '';
    _estAmountController
      ..text = (opportunity.estAmount != null
          ? opportunity.estAmount.toString()
          : '');
    _estProbabilityController
      ..text = (opportunity.estProbability != null
          ? opportunity.estProbability.toString()
          : '');
    _estNextStepController
      ..text =
          (opportunity.nextStep != null ? opportunity.nextStep.toString() : '');
    if (_selectedLead == null && opportunity.leadPartyId != null) {
      _selectedLead = User(
          partyId: opportunity.leadPartyId,
          email: opportunity.leadEmail,
          firstName: opportunity.leadFirstName,
          lastName: opportunity.leadLastName);
    }
    if (_selectedAccount == null && opportunity.accountPartyId != null) {
      _selectedAccount = User(
          partyId: opportunity.accountPartyId,
          email: opportunity.accountEmail,
          firstName: opportunity.accountFirstName,
          lastName: opportunity.accountLastName);
    }
    if (_selectedStageId == null && opportunity.stageId != null)
      _selectedStageId = opportunity.stageId ?? opportunityStages[0];

    Future<List<User>> getData(userGroupId, filter) async {
      var response = await repos.getUser(
          userGroupId: userGroupId, filter: _leadSearchBoxController.text);
      return response;
    }

    int columns = ResponsiveWrapper.of(context).isSmallerThan(TABLET) ? 1 : 2;
    return Center(
        child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Builder(
                    builder: (context) => GestureDetector(
                        onTap: () {},
                        child: Dialog(
                          insetPadding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                              width: columns.toDouble() * 400,
                              height: 1 / columns.toDouble() * 900,
                              child: _opportunityForm(
                                  opportunity, columns, getData)),
                        ))))));
  }

  Widget _opportunityForm(Opportunity? opportunity, int columns, getData) {
    return Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.all(15),
            child: GridView.count(
                crossAxisCount: columns,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: (5.5),
                children: <Widget>[
                  TextFormField(
                    key: Key('name'),
                    decoration: InputDecoration(labelText: 'Opportunity Name'),
                    controller: _nameController,
                    validator: (value) {
                      if (value!.isEmpty)
                        return 'Please enter a opportunity name?';
                      return null;
                    },
                  ),
                  TextFormField(
                    key: Key('description'),
                    decoration: InputDecoration(labelText: 'Description'),
                    controller: _descriptionController,
                  ),
                  TextFormField(
                    key: Key('EstAmount'),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp('[0-9.,]+'))
                    ],
                    decoration:
                        InputDecoration(labelText: 'Expected revenue Amount'),
                    controller: _estAmountController,
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter an amount?';
                      return null;
                    },
                  ),
                  TextFormField(
                    key: Key('EstProb'),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    decoration:
                        InputDecoration(labelText: 'Estimated Probabilty %'),
                    controller: _estProbabilityController,
                    validator: (value) {
                      if (value!.isEmpty)
                        return 'Please enter a probability % (1-100)?';
                      return null;
                    },
                  ),
                  TextFormField(
                    key: Key('NextStep'),
                    decoration: InputDecoration(labelText: 'Next step'),
                    controller: _estNextStepController,
                    validator: (value) {
                      if (value!.isEmpty) return 'Next step?';
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    key: Key('dropDownStage'),
                    hint: Text('Opportunity Stage'),
                    value: _selectedStageId,
                    validator: (value) =>
                        value == null ? 'field required' : null,
                    items: opportunityStages.map((item) {
                      return DropdownMenuItem<String>(
                          child: Text(item), value: item);
                    }).toList(),
                    onChanged: (String? newValue) {
                      _selectedStageId = newValue;
                    },
                    isExpanded: true,
                  ),
                  DropdownSearch<User>(
                    label: 'Lead',
                    dialogMaxWidth: 300,
                    autoFocusSearchBox: true,
                    selectedItem: _selectedLead,
                    dropdownSearchDecoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                    ),
                    searchBoxDecoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                    ),
                    showSearchBox: true,
                    searchBoxController: _leadSearchBoxController,
                    isFilteredOnline: true,
                    showClearButton: true,
                    key: Key('dropDownLead'),
                    itemAsString: (User? u) =>
                        "${u?.firstName}, ${u?.lastName} "
                        "${u?.companyName}",
                    onFind: (String filter) => getData(
                        "GROWERP_M_LEAD", _leadSearchBoxController.text),
                    onChanged: (User? newValue) {
                      _selectedLead = newValue;
                    },
                  ),
                  Visibility(
                      visible: opportunity?.opportunityId != null,
                      child: DropdownSearch<User>(
                          label: 'Account Employee',
                          dialogMaxWidth: 300,
                          autoFocusSearchBox: true,
                          selectedItem: _selectedAccount,
                          dropdownSearchDecoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                          ),
                          searchBoxDecoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                          ),
                          showSearchBox: true,
                          searchBoxController: _accountSearchBoxController,
                          isFilteredOnline: true,
                          showClearButton: true,
                          key: Key('dropDownAccount'),
                          itemAsString: (User? u) =>
                              "${u?.firstName} ${u?.lastName} "
                              "${u?.companyName}",
                          onFind: (String filter) => getData(
                              "GROWERP_M_EMPLOYEE",
                              _accountSearchBoxController.text),
                          onChanged: (User? newValue) {
                            _selectedAccount = newValue;
                          })),
                  ElevatedButton(
                      key: Key('cancel'),
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  ElevatedButton(
                      key: Key('update'),
                      child: Text(opportunity?.opportunityId == null
                          ? 'Create'
                          : 'Update'),
                      onPressed: () {
                        if (_formKey.currentState!.validate() && !loading) {
                          BlocProvider.of<OpportunityBloc>(context)
                              .add(UpdateOpportunity(Opportunity(
                            opportunityId: opportunity?.opportunityId,
                            opportunityName: _nameController.text,
                            description: _descriptionController.text,
                            estAmount: Decimal.parse(_estAmountController.text),
                            estProbability:
                                int.parse(_estProbabilityController.text),
                            stageId: _selectedStageId,
                            nextStep: _estNextStepController.text,
                            accountPartyId: _selectedAccount?.partyId,
                            accountFirstName: _selectedAccount?.firstName,
                            accountLastName: _selectedAccount?.lastName,
                            accountEmail: _selectedAccount?.email,
                            leadPartyId: _selectedLead?.partyId,
                            leadFirstName: _selectedLead?.firstName,
                            leadLastName: _selectedLead?.lastName,
                            leadEmail: _selectedLead?.email,
                          )));
                        }
                      }),
                ])));
  }
}