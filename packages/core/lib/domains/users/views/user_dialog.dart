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
import 'package:core/services/api_result.dart';
import 'package:core/widgets/dialogCloseButton.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:core/templates/@templates.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:core/domains/domains.dart';
import 'package:core/api_repository.dart';

/// User dialog with a required User class input containing the userGroup
class UserDialog extends StatelessWidget {
  final User user;
  const UserDialog({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserPage(user);
  }
}

class UserPage extends StatefulWidget {
  final User user;
  UserPage(this.user);
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<UserPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nameController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  final _companySearchBoxController = TextEditingController();

  bool loading = false;
  late List<UserGroup> localUserGroups;
  late UserGroup _selectedUserGroup;
  Company? _selectedCompany;
  XFile? _imageFile;
  dynamic _pickImageError;
  String? _retrieveDataError;
  late User updatedUser;
  late Authenticate authenticate;
  late APIRepository repos;
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  late bool isPhone;

  @override
  void initState() {
    super.initState();
    if (widget.user.partyId != null) {
      _firstNameController.text = widget.user.firstName ?? '';
      _lastNameController.text = widget.user.lastName ?? '';
      _nameController.text = widget.user.loginName ?? '';
      _telephoneController.text = widget.user.telephoneNr ?? '';
      _emailController.text = widget.user.email ?? '';
      _selectedCompany = Company(
          partyId: widget.user.companyPartyId, name: widget.user.companyName);
    }
    _selectedUserGroup = widget.user.userGroup ?? UserGroup.Undefined;
    ;
    localUserGroups = UserGroup.companyUserGroupList();
    updatedUser = widget.user;
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
    isPhone = ResponsiveWrapper.of(context).isSmallerThan(TABLET);
    repos = context.read<APIRepository>();
    User? user = widget.user;
    return Dialog(
        key: Key('UserDialog${user.userGroup.toString()}'),
        insetPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(clipBehavior: Clip.none, children: [
          SingleChildScrollView(
            key: Key('listView'),
            child: Container(
                padding: EdgeInsets.all(20),
                width: 400,
                height: 1020,
                child: BlocListener<UserBloc, UserState>(listener:
                    (context, state) {
                  if (state.status == UserStatus.failure) {
                    loading = false;
                    HelperFunctions.showMessage(
                        context, '${state.message}', Colors.red);
                  }
                  if (state.status == UserStatus.success) {
                    Navigator.of(context).pop(updatedUser);
                  }
                }, child:
                    BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                  authenticate = state.authenticate!;
                  if (widget.user.userGroup == UserGroup.Admin ||
                      widget.user.userGroup == UserGroup.Employee)
                    _selectedCompany = authenticate.company;
                  return ScaffoldMessenger(
                      key: scaffoldMessengerKey,
                      child: Scaffold(
                          backgroundColor: Colors.transparent,
                          floatingActionButton:
                              imageButtons(context, _onImageButtonPressed),
                          body: listChild()));
                }))),
          ),
          Positioned(top: -10, right: -10, child: DialogCloseButton())
        ]));
  }

  Widget listChild() {
    return Builder(builder: (BuildContext context) {
      return !kIsWeb && defaultTargetPlatform == TargetPlatform.android
          ? FutureBuilder<void>(
              future: retrieveLostData(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    'Pick image error: ${snapshot.error}}',
                    textAlign: TextAlign.center,
                  );
                }
                return _showForm();
              })
          : _showForm();
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

  Widget _showForm() {
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
    return _userDialog();
  }

  Widget _userDialog() {
    String? companyName = authenticate.company!.name;
    User? currentUser = authenticate.user;

    Future<List<Company>> getOwnedCompanies(filter) async {
      ApiResult<List<Company>> result = await repos.getCompanies(
          filter: _companySearchBoxController.text, mainCompanies: false);
      return result.when(
          success: (data) => data,
          failure: (_) => [Company(name: 'get data error!')]);
    }

    return Form(
        key: _formKey,
        child: Column(children: <Widget>[
          Center(
              child: Text(
            'User ${widget.user.userGroup.toString()} #${updatedUser.partyId ?? " New"}',
            style: TextStyle(
                fontSize: isPhone ? 10 : 20,
                color: Colors.black,
                fontWeight: FontWeight.bold),
            key: Key('header'),
          )),
          Center(
              child: Text(
            'Company #${updatedUser.companyPartyId ?? ""}',
            style: TextStyle(
                fontSize: isPhone ? 10 : 20,
                color: Colors.black,
                fontWeight: FontWeight.bold),
            key: Key('compHeader'),
          )),
          Visibility(
              visible: updatedUser.userGroup == UserGroup.Admin ||
                  updatedUser.userGroup == UserGroup.Employee,
              child: Center(child: Text(companyName!))),
          SizedBox(height: 10),
          CircleAvatar(
              backgroundColor: Colors.green,
              radius: 80,
              child: _imageFile != null
                  ? kIsWeb
                      ? Image.network(_imageFile!.path)
                      : Image.file(File(_imageFile!.path))
                  : widget.user.image != null
                      ? Image.memory(widget.user.image!, height: 150)
                      : Text(widget.user.firstName?.substring(0, 1) ?? '',
                          style: TextStyle(fontSize: 30, color: Colors.black))),
          SizedBox(height: 20),
          TextFormField(
            key: Key('firstName'),
            decoration: InputDecoration(labelText: 'First Name'),
            controller: _firstNameController,
            validator: (value) {
              if (value!.isEmpty) return 'Please enter a first name?';
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            key: Key('lastName'),
            decoration: InputDecoration(labelText: 'Last Name'),
            controller: _lastNameController,
            validator: (value) {
              if (value!.isEmpty) return 'Please enter a last name?';
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            key: Key('loginName'),
            decoration: InputDecoration(labelText: 'User Login Name '),
            controller: _nameController,
            validator: (value) {
              if (widget.user.userGroup == UserGroup.Admin && value!.isEmpty)
                return 'An administrator needs a username!';
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            key: Key('telephoneNr'),
            decoration: InputDecoration(labelText: 'Telephone number'),
            controller: _telephoneController,
          ),
          SizedBox(height: 10),
          TextFormField(
            key: Key('email'),
            decoration: InputDecoration(labelText: 'Email address'),
            controller: _emailController,
            validator: (String? value) {
              if (value!.isEmpty) return 'Please enter Email address?';
              if (!RegExp(
                      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                  .hasMatch(value)) {
                return 'This is not a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          Visibility(
              visible: updatedUser.userGroup != UserGroup.Admin &&
                  updatedUser.userGroup != UserGroup.Employee,
              child: Column(children: [
                TextFormField(
                  key: Key('newCompanyName'),
                  decoration: InputDecoration(labelText: 'New Company Name'),
                  controller: _companyController,
                  validator: (value) {
                    if (value!.isEmpty && _selectedCompany == null)
                      return 'Please enter an existing or new company?';
                    return null;
                  },
                ),
                SizedBox(height: 10),
                DropdownSearch<Company>(
                  key: Key('companyName'),
                  dialogMaxWidth: 300,
                  searchFieldProps: TextFieldProps(
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                    ),
                    controller: _companySearchBoxController,
                  ),
                  selectedItem: _selectedCompany,
                  popupShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'Existing Company',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                  ),
                  showSearchBox: true,
                  isFilteredOnline: true,
                  itemAsString: (Company? u) => "${u!.name}",
                  onFind: (String? filter) =>
                      getOwnedCompanies(_companySearchBoxController.text),
                  onChanged: (Company? newValue) {
                    setState(() {
                      _selectedCompany = newValue;
                    });
                  },
                  validator: (value) =>
                      value == null && _companyController.text == ''
                          ? "Select an existing or Create a new company"
                          : null,
                )
              ])),
          SizedBox(height: 10),
          Visibility(
              // use only to modify by admin user
              visible: updatedUser.partyId != null &&
                  currentUser!.userGroup == UserGroup.Admin,
              child: DropdownButtonFormField<UserGroup>(
                decoration: InputDecoration(labelText: 'User Group'),
                key: Key('userGroup'),
                hint: Text('User Group'),
                value: _selectedUserGroup,
                validator: (value) => value == null ? 'field required' : null,
                items: localUserGroups.map((item) {
                  return DropdownMenuItem<UserGroup>(
                      child: Text(item.toString()), value: item);
                }).toList(),
                onChanged: (UserGroup? newValue) {
                  setState(() {
                    _selectedUserGroup = newValue!;
                  });
                },
                isExpanded: true,
              )),
          SizedBox(height: 10),
          Visibility(
              visible: updatedUser.userGroup != UserGroup.Admin &&
                  updatedUser.userGroup != UserGroup.Employee &&
                  updatedUser.partyId != null,
              child: Row(children: [
                Expanded(
                    child: Text(
                        updatedUser.companyAddress != null
                            ? "${updatedUser.companyAddress!.city!} "
                                "${updatedUser.companyAddress!.country!}"
                            : "No address yet",
                        key: Key('addressLabel'))),
                SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      key: Key('address'),
                      onPressed: () async {
                        var result = await showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (BuildContext context) {
                              return AddressDialog(
                                  address: updatedUser.companyAddress);
                            });
                        if (result is Address)
                          context.read<UserBloc>().add(UserUpdate(
                              updatedUser.copyWith(companyAddress: result)));
                      },
                      child: Text(updatedUser.companyAddress != null
                          ? 'Update\nAddress'
                          : 'Add\nAddress'),
                    ))
              ])),
          SizedBox(height: 10),
          Visibility(
              visible: updatedUser.userGroup != UserGroup.Admin &&
                  updatedUser.userGroup != UserGroup.Employee &&
                  updatedUser.partyId != null,
              child: Row(children: [
                Expanded(
                    child: Text(
                        updatedUser.companyPaymentMethod != null
                            ? "${updatedUser.companyPaymentMethod?.ccDescription}"
                            : "No payment methods yet",
                        key: Key('paymentMethodLabel'))),
                SizedBox(
                    width: 100,
                    child: ElevatedButton(
                        key: Key('paymentMethod'),
                        onPressed: () async {
                          var result = await showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return PaymentMethodDialog(
                                    paymentMethod:
                                        updatedUser.companyPaymentMethod);
                              });
                          if (result is PaymentMethod)
                            context.read<UserBloc>().add(UserUpdate(updatedUser
                                .copyWith(companyPaymentMethod: result)));
                        },
                        child: Text((updatedUser.companyPaymentMethod != null
                                ? 'Update'
                                : 'Add') +
                            ' Payment Method')))
              ])),
          SizedBox(height: 10),
          Row(children: [
            Expanded(
                child: ElevatedButton(
                    key: Key('updateUser'),
                    child:
                        Text(updatedUser.partyId == null ? 'Create' : 'Update'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        updatedUser = updatedUser.copyWith(
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            email: _emailController.text,
                            loginName: _nameController.text,
                            telephoneNr: _telephoneController.text,
                            userGroup: _selectedUserGroup,
                            language: Localizations.localeOf(context)
                                .languageCode
                                .toString(),
                            companyName: _companyController.text,
                            // if new company name not empty partyId
                            companyPartyId: _companyController.text.isEmpty
                                ? updatedUser.companyPartyId
                                : '',
                            image: await HelperFunctions.getResizedImage(
                                _imageFile?.path));
                        if (_imageFile?.path != null &&
                            updatedUser.image == null)
                          HelperFunctions.showMessage(
                              context,
                              "Image upload error or larger than 200K",
                              Colors.red);
                        else
                          context.read<UserBloc>().add(UserUpdate(updatedUser));
                      }
                    }))
          ])
        ]));
  }
}
