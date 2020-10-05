/*
 * This software is in the public domain under CC0 1.0 Universal plus a
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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../models/@models.dart';
import '../blocs/@blocs.dart';
import '../helper_functions.dart';
import '../routing_constants.dart';

class CompanyForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Authenticate authenticate;
    Company company;
    bool isAdmin = false;
    return Scaffold(
        appBar: AppBar(title: const Text('Company page'), actions: <Widget>[
          IconButton(
              icon: Icon(Icons.home),
              onPressed: () => Navigator.pushNamed(context, HomeRoute)),
        ]),
        body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
          if (state is AuthCompanyUpdateSuccess) {
            HelperFunctions.showMessage(context,
                'Company ${authenticate.company.name} updated', Colors.green);
          }
          if (state is AuthProblem) {
            company = state.newCompany;
            HelperFunctions.showMessage(
                context, '${state.errorMessage}', Colors.red);
          }
        }, builder: (context, state) {
          if (state is AuthUnauthenticated) {
            authenticate = state.authenticate;
            company = authenticate.company;
          }
          if (state is AuthAuthenticated) {
            authenticate = state.authenticate;
            if (company == null) company = authenticate.company;
            isAdmin = authenticate?.user?.userGroupId == 'GROWERP_M_ADMIN';
          }
          return CompanyPage(authenticate, isAdmin, company);
        }));
  }
}

class CompanyPage extends StatefulWidget {
  final Authenticate authenticate;
  final bool isAdmin;
  final Company company;
  CompanyPage(this.authenticate, this.isAdmin, this.company);
  @override
  _CompanyState createState() => _CompanyState(authenticate);
}

class _CompanyState extends State<CompanyPage> {
  final Authenticate authenticate;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  Currency _selectedCurrency;
  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;
  final ImagePicker _picker = ImagePicker();

  _CompanyState(this.authenticate);

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(
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
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
            ? FutureBuilder<void>(
                future: retrieveLostData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  if (snapshot.hasError) {
                    return Text(
                      'Pick image error: ${snapshot.error}}',
                      textAlign: TextAlign.center,
                    );
                  }
                  return _showForm(widget.isAdmin, widget.company);
                })
            : _showForm(widget.isAdmin, widget.company),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 60),
          Visibility(
              visible: widget.isAdmin,
              child: FloatingActionButton(
                onPressed: () {
                  _onImageButtonPressed(ImageSource.gallery, context: context);
                },
                heroTag: 'image0',
                tooltip: 'Pick Image from gallery',
                child: const Icon(Icons.photo_library),
              )),
          SizedBox(height: 20),
          Visibility(
              visible: widget.isAdmin,
              child: FloatingActionButton(
                onPressed: () {
                  _onImageButtonPressed(ImageSource.camera, context: context);
                },
                heroTag: 'image1',
                tooltip: 'Take a Photo',
                child: const Icon(Icons.camera_alt),
              )),
        ],
      ),
    );
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _showForm(isAdmin, company) {
    _nameController..text = company.name;
    _emailController..text = company.email;
    Company updatedCompany;

    final Text retrieveError = _getRetrieveErrorWidget();
    if (_selectedCurrency == null &&
        company?.currencyId != null &&
        currencies != null)
      _selectedCurrency =
          currencies.firstWhere((a) => a.currencyId == company.currencyId);
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    }
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, updatedCompany);
          return false;
        },
        child: Center(
            child: Container(
                width: 400,
                child: Form(
                    key: _formKey,
                    child: ListView(children: <Widget>[
                      SizedBox(height: 30),
                      CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 80,
                          child: _imageFile != null
                              ? kIsWeb
                                  ? Image.network(_imageFile.path)
                                  : Image.file(File(_imageFile.path))
                              : company.image != null
                                  ? Image.memory(company.image)
                                  : Text(company.name.substring(0, 1) ?? '',
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.black))),
                      SizedBox(height: 20),
                      TextFormField(
                        readOnly: !isAdmin,
                        key: Key('companyName'),
                        decoration: InputDecoration(labelText: 'Company Name'),
                        controller: _nameController,
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please enter the company Name?';
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        readOnly: !isAdmin,
                        key: Key('email'),
                        decoration:
                            InputDecoration(labelText: 'Company Email address'),
                        controller: _emailController,
                        validator: (String value) {
                          if (value.isEmpty)
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
                      IgnorePointer(
                          ignoring: !isAdmin,
                          child: Container(
                            width: 400,
                            height: 60,
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 0.80),
                            ),
                            child: DropdownButton<Currency>(
                              key: Key('dropDown'),
                              underline: SizedBox(), // remove underline
                              hint: Text('Currency'),
                              value: _selectedCurrency,
                              items: currencies?.map((item) {
                                return DropdownMenuItem<Currency>(
                                    child: Text(item.description), value: item);
                              })?.toList(),
                              onChanged: (Currency newValue) {
                                setState(() {
                                  _selectedCurrency = newValue;
                                });
                              },
                              isExpanded: true,
                            ),
                          )),
                      SizedBox(height: 20),
                      Visibility(
                          visible: isAdmin,
                          child: RaisedButton(
                              key: Key('update'),
                              child: Text(company.partyId == null
                                  ? 'Create'
                                  : 'Update'),
                              onPressed: () async {
                                if (_formKey.currentState.validate())
                                  //&& state is! UsersLoading)
                                  updatedCompany = Company(
                                    partyId: company.partyId,
                                    email: _emailController.text,
                                    name: _nameController.text,
                                    currencyId: _selectedCurrency.currencyId,
                                  );
                                authenticate.company = updatedCompany;
                                BlocProvider.of<AuthBloc>(context)
                                    .add(UpdateCompany(
                                  authenticate,
                                  updatedCompany,
                                  _imageFile?.path,
                                ));
                              }))
                    ])))));
  }
}
