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

import 'dart:io';
import 'package:core/domains/common/functions/helper_functions.dart';
import 'package:core/templates/@templates.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:core/domains/domains.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CompanyInfoForm extends StatelessWidget {
  final FormArguments formArguments;
  CompanyInfoForm(this.formArguments);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return CompanyPage(formArguments.message, state.authenticate!);
    });
  }
}

class CompanyPage extends StatefulWidget {
  final String? message;
  final Authenticate authenticate;
  CompanyPage(this.message, this.authenticate);

  @override
  _CompanyState createState() => _CompanyState(message, authenticate);
}

class _CompanyState extends State<CompanyPage> {
  final String? message;
  final Authenticate authenticate;
  final _formKey = GlobalKey<FormState>();
  late Company company;
  late User user;
  Address? companyAddress;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _vatPercController = TextEditingController();
  TextEditingController _salesPercController = TextEditingController();
  late Currency _selectedCurrency;
  late bool isAdmin;
  XFile? _imageFile;
  dynamic _pickImageError;
  String? _retrieveDataError;
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  _CompanyState(this.message, this.authenticate) {
    HelperFunctions.showTopMessage(scaffoldMessengerKey, message);
  }

  @override
  void initState() {
    super.initState();
    company = authenticate.company!;
    user = authenticate.user!;
    companyAddress = authenticate.company!.address;
    isAdmin = authenticate.user!.userGroup == UserGroup.Admin;
    _selectedCurrency = currencies.firstWhere((element) =>
        element.currencyId == authenticate.company?.currency?.currencyId);
    _nameController..text = company.name!;
    _emailController..text = company.email!;
    _vatPercController
      ..text = company.vatPerc == null ? '' : company.vatPerc.toString();
    _salesPercController
      ..text = company.salesPerc == null ? '' : company.salesPerc.toString();
  }

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      switch (state.status) {
        case AuthStatus.authenticated:
          HelperFunctions.showMessage(
              context, '${state.message}', Colors.green);
          break;
        case AuthStatus.failure:
          HelperFunctions.showMessage(context, '${state.message}', Colors.red);
          break;
        default:
      }
    }, builder: (context, state) {
      switch (state.status) {
        case AuthStatus.failure:
          return Center(
              child: Text('failed to fetch company info ${state.message}'));
        case AuthStatus.authenticated:
          return ScaffoldMessenger(
              key: scaffoldMessengerKey,
              child: Scaffold(
                  floatingActionButton:
                      imageButtons(context, _onImageButtonPressed),
                  body: Center(
                    child: !kIsWeb &&
                            defaultTargetPlatform == TargetPlatform.android
                        ? FutureBuilder<void>(
                            future: retrieveLostData(),
                            builder: (BuildContext context,
                                AsyncSnapshot<void> snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                  'Pick image error: ${snapshot.error}}',
                                  textAlign: TextAlign.center,
                                );
                              }
                              return _showForm(authenticate, isAdmin, company);
                            })
                        : _showForm(authenticate, isAdmin, company),
                  )));

        default:
          return LoadingIndicator();
      }
    });
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _showForm(Authenticate authenticate, bool isAdmin, Company company) {
    bool isPhone = ResponsiveWrapper.of(context).isSmallerThan(TABLET);
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    }
    return Center(
        child: Container(
            width: 400,
            child: SingleChildScrollView(
                key: Key('listView'),
                child: Form(
                    key: _formKey,
                    child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(children: [
                          Center(
                              child: Text(
                            'id:#${authenticate.company!.partyId}',
                            style: TextStyle(
                                fontSize: isPhone ? 10 : 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            key: Key('header'),
                          )),
                          SizedBox(height: 10),
                          CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 80,
                              child: _imageFile != null
                                  ? kIsWeb
                                      ? Image.network(_imageFile!.path)
                                      : Image.file(File(_imageFile!.path))
                                  : company.image != null
                                      ? Image.memory(company.image!)
                                      : Text(
                                          company.name!.isNotEmpty
                                              ? company.name!.substring(0, 1)
                                              : '?',
                                          style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.black))),
                          SizedBox(height: 10),
                          TextFormField(
                            readOnly: !isAdmin,
                            key: Key('companyName'),
                            decoration:
                                InputDecoration(labelText: 'Company Name'),
                            controller: _nameController,
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Please enter the company Name?';
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            readOnly: !isAdmin,
                            key: Key('email'),
                            decoration: InputDecoration(
                                labelText: 'Company Email address'),
                            controller: _emailController,
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Please enter Email address?';
                              if (!RegExp(
                                      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                  .hasMatch(value)) {
                                return 'This is not a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField<Currency>(
                            key: Key('currency'),
                            decoration: InputDecoration(labelText: 'Currency'),
                            hint: Text('Currency'),
                            value: _selectedCurrency,
                            items: currencies.map((item) {
                              return DropdownMenuItem<Currency>(
                                  child: Text(item.description!), value: item);
                            }).toList(),
                            onChanged: isAdmin
                                ? (Currency? newValue) {
                                    setState(() {
                                      _selectedCurrency = newValue!;
                                    });
                                  }
                                : null,
                            isExpanded: true,
                          ),
                          SizedBox(height: 10),
                          Row(children: [
                            Expanded(
                                child: TextFormField(
                              key: Key('vatPerc'),
                              readOnly: !isAdmin,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              decoration:
                                  InputDecoration(labelText: 'VAT. percentage'),
                              controller: _vatPercController,
                            )),
                            SizedBox(width: 10),
                            Expanded(
                                child: TextFormField(
                              key: Key('salesPerc'),
                              readOnly: !isAdmin,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              decoration: InputDecoration(
                                  labelText: 'Sales Tax percentage'),
                              controller: _salesPercController,
                            ))
                          ]),
                          SizedBox(height: 10),
                          Row(children: [
                            Expanded(
                                child: Text(
                                    companyAddress != null
                                        ? "${companyAddress!.city!} ${companyAddress!.country!}"
                                        : "No address yet",
                                    key: Key('addressLabel'))),
                            SizedBox(
                                width: 100,
                                child: ElevatedButton(
                                  key: Key('address'),
                                  onPressed: isAdmin
                                      ? () async {
                                          var result = await showDialog(
                                              barrierDismissible: true,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AddressDialog(
                                                    address: companyAddress);
                                              });
                                          if (result is Address)
                                            setState(() {
                                              companyAddress = result;
                                            });
                                        }
                                      : null,
                                  child: Text(company.address != null
                                      ? 'Update\nAddress'
                                      : 'Add\nAddress'),
                                ))
                          ]),
                          SizedBox(height: 10),
                          Row(children: [
                            Expanded(
                                child: Visibility(
                                    visible: isAdmin,
                                    child: ElevatedButton(
                                        key: Key('updateCompany'),
                                        child: Text(
                                          company.partyId == null
                                              ? 'Create'
                                              : 'Update',
                                        ),
                                        onPressed: isAdmin
                                            ? () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  //        && !Loading)
                                                  company = Company(
                                                      partyId: company.partyId,
                                                      email:
                                                          _emailController.text,
                                                      name:
                                                          _nameController.text,
                                                      currency:
                                                          _selectedCurrency,
                                                      address: companyAddress,
                                                      vatPerc: Decimal.parse(
                                                          _vatPercController
                                                                  .text.isEmpty
                                                              ? '0'
                                                              : _vatPercController
                                                                  .text),
                                                      salesPerc: Decimal.parse(
                                                          _salesPercController
                                                                  .text.isEmpty
                                                              ? '0'
                                                              : _salesPercController
                                                                  .text),
                                                      image: await HelperFunctions
                                                          .getResizedImage(
                                                              _imageFile?.path));
                                                  if (_imageFile?.path !=
                                                          null &&
                                                      company.image == null)
                                                    HelperFunctions.showMessage(
                                                        context,
                                                        "Image upload error or larger than 200K",
                                                        Colors.red);
                                                  else
                                                    BlocProvider.of<AuthBloc>(
                                                            context)
                                                        .add(AuthUpdateCompany(
                                                            company));
                                                }
                                              }
                                            : null)))
                          ])
                        ]))))));
  }
}
