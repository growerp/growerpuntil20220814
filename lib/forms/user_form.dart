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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:models/@models.dart';
import 'package:core/blocs/@blocs.dart';
import 'package:core/helper_functions.dart';
import 'package:core/widgets/@widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';

class UserForm extends StatelessWidget {
  final FormArguments formArguments;
  UserForm(this.formArguments);

  @override
  Widget build(BuildContext context) {
    var a = (formArguments) =>
        (MyUserPage(formArguments.message, formArguments.object));
    return ShowNavigationRail(a(formArguments), formArguments.tab);
  }
}

class MyUserPage extends StatefulWidget {
  final String message;
  final User user;
  MyUserPage(this.message, this.user);
  @override
  _MyUserState createState() => _MyUserState(message, user);
}

class _MyUserState extends State<MyUserPage> {
  final String message;
  final User user;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  User updatedUser;
  bool loading = false;
  UserGroup _selectedUserGroup;
  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  _MyUserState([this.message, this.user]) {
    HelperFunctions.showTopMessage(scaffoldMessengerKey, message);
  }

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
    Authenticate authenticate;
    updatedUser = widget.user;
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) authenticate = state.authenticate;
      return ScaffoldMessenger(
          key: scaffoldMessengerKey,
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading:
                    ResponsiveWrapper.of(context).isSmallerThan(TABLET),
                title: companyLogo(context, authenticate,
                    '${user?.groupDescription} detail #${user.partyId}'),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.home),
                      onPressed: () => Navigator.pushNamed(context, '/home'))
                ],
              ),
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 100),
                  FloatingActionButton(
                    onPressed: () {
                      _onImageButtonPressed(ImageSource.gallery,
                          context: context);
                    },
                    heroTag: 'image0',
                    tooltip: 'Pick Image from gallery',
                    child: const Icon(Icons.photo_library),
                  ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: !kIsWeb,
                    child: FloatingActionButton(
                      onPressed: () {
                        _onImageButtonPressed(ImageSource.camera,
                            context: context);
                      },
                      heroTag: 'image1',
                      tooltip: 'Take a Photo',
                      child: const Icon(Icons.camera_alt),
                    ),
                  )
                ],
              ),
              drawer: myDrawer(context, authenticate),
              body: user.userGroupId == "GROWERP_M_EMPLOYEE"
                  ? BlocListener<EmployeeBloc, UserState>(
                      listener: (context, state) {
                        listListener(state);
                      },
                      child: listChild(authenticate))
                  : user.userGroupId == "GROWERP_M_ADMIN"
                      ? BlocListener<AdminBloc, UserState>(
                          listener: (context, state) {
                            listListener(state);
                          },
                          child: listChild(authenticate))
                      : user.userGroupId == "GROWERP_M_SUPPLIER"
                          ? BlocListener<SupplierBloc, UserState>(
                              listener: (context, state) {
                                listListener(state);
                              },
                              child: listChild(authenticate))
                          : user.userGroupId == "GROWERP_M_LEAD"
                              ? BlocListener<LeadBloc, UserState>(
                                  listener: (context, state) {
                                    listListener(state);
                                  },
                                  child: listChild(authenticate))
                              : BlocListener<CustomerBloc, UserState>(
                                  listener: (context, state) {
                                    listListener(state);
                                  },
                                  child: listChild(authenticate))));
    });
  }

  Widget listChild(authenticate) {
    return Center(child: Builder(builder: (BuildContext context) {
      return Center(
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
                  return _showForm(authenticate, updatedUser);
                })
            : _showForm(authenticate, updatedUser),
      );
    }));
  }

  listListener(state) {
    if (state is UserProblem) {
      loading = false;
      HelperFunctions.showMessage(context, '${state.errorMessage}', Colors.red);
    }
    if (state is UserLoading) {
      loading = true;
      HelperFunctions.showMessage(context, '${state.message}', Colors.green);
    }
    if (state is UserSuccess) {
      Navigator.of(context).pop();
    }
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _showForm(authenticate, updatedUser) {
    _firstNameController..text = user?.firstName;
    _lastNameController..text = user?.lastName;
    _nameController..text = user?.name;
    _emailController..text = user?.email;
    _companyController..text = user?.companyName;
    final Text retrieveError = _getRetrieveErrorWidget();
    if (_selectedUserGroup == null && user?.userGroupId != null)
      _selectedUserGroup =
          userGroups.firstWhere((a) => a.userGroupId == user?.userGroupId);
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
                          : user?.image != null
                              ? Image.memory(user?.image, height: 150)
                              : Text(user?.firstName?.substring(0, 1) ?? '',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.black))),
                  SizedBox(height: 20),
                  TextFormField(
                    key: Key('firstName'),
                    decoration: InputDecoration(labelText: 'First Name'),
                    controller: _firstNameController,
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter a first name?';
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    key: Key('lastName'),
                    decoration: InputDecoration(labelText: 'Last Name'),
                    controller: _lastNameController,
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter a last name?';
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    key: Key('name'),
                    decoration: InputDecoration(labelText: 'User Login Name'),
                    controller: _nameController,
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter a login name?';
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    key: Key('email'),
                    decoration: InputDecoration(labelText: 'Email address'),
                    controller: _emailController,
                    validator: (String value) {
                      if (value.isEmpty) return 'Please enter Email address?';
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
                      visible: user.userGroupId == null,
                      child: DropdownButtonFormField<UserGroup>(
                        key: Key('dropDown'),
                        hint: Text('User Group'),
                        value: _selectedUserGroup,
                        validator: (value) =>
                            value == null ? 'field required' : null,
                        items: userGroups?.map((item) {
                          return DropdownMenuItem<UserGroup>(
                              child: Text(item.description), value: item);
                        })?.toList(),
                        onChanged: (UserGroup newValue) {
                          setState(() {
                            _selectedUserGroup = newValue;
                          });
                        },
                        isExpanded: true,
                      )),
                  SizedBox(height: 10),
                  Visibility(
                      visible: user.userGroupId != 'GROWERP_M_ADMIN' &&
                          user.userGroupId != 'GROWERP_M_EMPLOYEE',
                      child: TextFormField(
                        key: Key('companyName'),
                        decoration: InputDecoration(labelText: 'Company Name'),
                        controller: _companyController,
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please enter a company name?';
                          return null;
                        },
                      )),
                  SizedBox(height: 10),
                  RaisedButton(
                      disabledColor: Colors.grey,
                      key: Key('update'),
                      child: Text(user?.partyId == null ? 'Create' : 'Update'),
                      onPressed: () async {
                        if (_formKey.currentState.validate() && !loading) {
                          updatedUser = User(
                              partyId: user?.partyId,
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              email: _emailController.text,
                              name: _nameController.text,
                              userGroupId: _selectedUserGroup.userGroupId,
                              language: Localizations.localeOf(context)
                                  .languageCode
                                  .toString(),
                              companyName: _companyController.text,
                              image: await HelperFunctions.getResizedImage(
                                  _imageFile?.path));
                          user.userGroupId == "GROWERP_M_EMPLOYEE"
                              ? BlocProvider.of<EmployeeBloc>(context)
                                  .add(UpdateUser(
                                  updatedUser,
                                ))
                              : user.userGroupId == "GROWERP_M_ADMIN"
                                  ? BlocProvider.of<AdminBloc>(context)
                                      .add(UpdateUser(
                                      updatedUser,
                                    ))
                                  : user.userGroupId == "GROWERP_M_SUPPLIER"
                                      ? BlocProvider.of<SupplierBloc>(context)
                                          .add(UpdateUser(
                                          updatedUser,
                                        ))
                                      : user.userGroupId == "GROWERP_M_LEAD"
                                          ? BlocProvider.of<LeadBloc>(context)
                                              .add(UpdateUser(
                                              updatedUser,
                                            ))
                                          : BlocProvider.of<CustomerBloc>(
                                                  context)
                                              .add(UpdateUser(
                                              updatedUser,
                                            ));
                        }
                      }),
                  SizedBox(height: 10),
                  RaisedButton(
                      key: Key('cancel'),
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ]))));
  }
}
