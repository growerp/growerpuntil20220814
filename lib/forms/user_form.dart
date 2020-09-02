import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../models/@models.dart';
import '../blocs/@blocs.dart';
import '../services/repos.dart';
import '../helper_functions.dart';
import '../routing_constants.dart';
import '@forms.dart';

class UserForm extends StatelessWidget {
  final String partyId;
  const UserForm(this.partyId);

  @override
  Widget build(BuildContext context) {
    Authenticate authenticate;
    User user;
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is! AuthAuthenticated) return NoAccessForm('Userlist');
      if (state is AuthAuthenticated) authenticate = state.authenticate;
      return BlocProvider(
          create: (_) => UsersBloc(
              repos: context.repository<Repos>(),
              companyPartyId: authenticate?.company?.partyId)
            ..add(LoadUser(this.partyId)),
          child: WillPopScope(
              onWillPop: () async {
                Navigator.pop(context, user);
                return;
              },
              child: Scaffold(
                  appBar: AppBar(
                    title: const Text('User page'),
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.home),
                          onPressed: () =>
                              Navigator.pushNamed(context, HomeRoute)),
                    ],
                  ),
                  body: BlocListener<UsersBloc, UsersState>(
                      listener: (context, state) {
                    if (state is UserLoaded) user = state?.user;
                    if (state is UsersError) {
                      HelperFunctions.showMessage(
                          context, '${state.errorMessage}', Colors.red);
                    }
                    if (state is UserUpdateSuccess) {
                      HelperFunctions.showMessage(
                          context, 'user added/updated', Colors.green);
                    }
                  }, child: BlocBuilder<UsersBloc, UsersState>(
                          builder: (context, state) {
                    if (state is UsersLoading)
                      return Center(child: CircularProgressIndicator());
                    if (state is UserLoaded) user = state?.user;
                    if (state is UserUpdateSuccess) user = state?.user;
                    return MyHomePage(user);
                  })))));
    });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(this.user);

  final User user;

  @override
  _MyHomePageState createState() => _MyHomePageState(user);
}

class _MyHomePageState extends State<MyHomePage> {
  final User user;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  UserGroup _selectedUserGroup;
  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;
  final ImagePicker _picker = ImagePicker();

  _MyHomePageState(this.user);

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
                  return _showForm();
                })
            : _showForm(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 60),
          FloatingActionButton(
            onPressed: () {
              _onImageButtonPressed(ImageSource.gallery, context: context);
            },
            heroTag: 'image0',
            tooltip: 'Pick Image from gallery',
            child: const Icon(Icons.photo_library),
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            onPressed: () {
              _onImageButtonPressed(ImageSource.camera, context: context);
            },
            heroTag: 'image1',
            tooltip: 'Take a Photo',
            child: const Icon(Icons.camera_alt),
          ),
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

  Widget _showForm() {
    _firstNameController..text = widget.user?.firstName;
    _lastNameController..text = user?.lastName;
    _nameController..text = user?.name;
    _emailController..text = user?.email;
    User updatedUser;
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
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, updatedUser);
          return false;
        },
        child: Center(
            child: Container(
                width: 400,
                child: Form(
                    key: _formKey,
                    child: ListView(children: <Widget>[
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: () async {
                          PickedFile pickedFile = await _picker.getImage(
                              source: ImageSource.gallery);
                          BlocProvider.of<UsersBloc>(context)
                              .add(UploadImage(user.partyId, pickedFile.path));
                        },
                        child: CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 80,
                            child: _imageFile != null
                                ? kIsWeb
                                    ? Image.network(_imageFile.path)
                                    : Image.file(File(_imageFile.path))
                                : user?.image != null
                                    ? Image.memory(user?.image)
                                    : Text(user?.firstName ?? '',
                                        style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.black))),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        key: Key('firstName'),
                        decoration: InputDecoration(labelText: 'First Name'),
                        controller: _firstNameController,
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please enter your first name?';
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        key: Key('lastName'),
                        decoration: InputDecoration(labelText: 'Last Name'),
                        controller: _lastNameController,
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please enter your last name?';
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        key: Key('name'),
                        decoration: InputDecoration(labelText: 'Login Name'),
                        controller: _nameController,
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please enter a login name?';
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        key: Key('email'),
                        decoration: InputDecoration(labelText: 'Email address'),
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
                      Container(
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
                        child: DropdownButton<UserGroup>(
                          key: Key('dropDown'),
                          underline: SizedBox(), // remove underline
                          hint: Text('User Group'),
                          value: _selectedUserGroup,
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
                        ),
                      ),
                      SizedBox(height: 20),
                      RaisedButton(
                          key: Key('update'),
                          child:
                              Text(user?.partyId == null ? 'Create' : 'Update'),
                          onPressed: () {
                            if (_formKey.currentState.validate())
                              //&& state is! UsersLoading)
                              updatedUser = User(
                                image: _imageFile != null
                                    ? File(_imageFile.path).readAsBytesSync()
                                    : null,
                                partyId: user?.partyId,
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                email: _emailController.text,
                                name: _nameController.text,
                                userGroupId: _selectedUserGroup.userGroupId,
                                language: Localizations.localeOf(context)
                                    .languageCode
                                    .toString(),
                                country: Localizations.localeOf(context)
                                    .languageCode
                                    .toString(),
                              );
                            BlocProvider.of<UsersBloc>(context).add(UpdateUser(
                              updatedUser,
                              _imageFile?.path,
                            ));
                          })
                    ])))));
  }
}
