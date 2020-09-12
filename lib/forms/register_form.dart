import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../blocs/@blocs.dart';
import '../models/@models.dart';
import '../services/repos.dart';
import '../helper_functions.dart';
import '../routing_constants.dart';

/// RegisterForm shows dual registration forms depending on:
///  Authenticate.company.partyId: (from AuthBloc)
///   when null show new company registration/admin
///   when present show customer registration for specified company.partyId
class RegisterForm extends StatelessWidget {
  final String message;
  const RegisterForm([this.message]);
  @override
  Widget build(BuildContext context) {
    Authenticate authenticate;
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      // always [AuthUnauthenticated] becaused not logged in
      if (state is AuthUnauthenticated) authenticate = state.authenticate;
      return Scaffold(
        key: Key('RegisterForm'),
        appBar: AppBar(
          title: Text(authenticate?.company?.partyId == null
              ? 'Register a new company and admin'
              : 'Register as a customer for ${authenticate?.company?.name}'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.home),
                onPressed: () => Navigator.pushNamed(context, HomeRoute)),
          ],
        ),
        body: BlocProvider(
          create: (context) =>
              RegisterBloc(repos: context.repository<Repos>())
                ..add(LoadRegister(
                    companyPartyId: authenticate?.company?.partyId,
                    companyName: authenticate?.company?.name)),
          child: RegisterHeader(message),
        ),
      );
    });
  }
}

class RegisterHeader extends StatefulWidget {
  final String message;
  const RegisterHeader(this.message);

  @override
  State<RegisterHeader> createState() => _RegisterHeaderState(message);
}

class _RegisterHeaderState extends State<RegisterHeader> {
  final String message;
  final _formKey = GlobalKey<FormState>();
  String _currencySelected = kReleaseMode ? '' : 'Thailand Baht [THB]';
  final _companyController = TextEditingController()
    ..text = kReleaseMode ? '' : 'Master template app';
  final _firstNameController = TextEditingController()
    ..text = kReleaseMode ? '' : 'John';
  final _lastNameController = TextEditingController()
    ..text = kReleaseMode ? '' : 'Doe';
  final _emailController = TextEditingController()
    ..text = kReleaseMode ? '' : 'admin@growerp.com';

  _RegisterHeaderState(this.message);

  @override
  void initState() {
    Future<Null>.delayed(Duration(milliseconds: 0), () {
      if (message != null)
        HelperFunctions.showMessage(context, '$message', Colors.green);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Authenticate authenticate;
    List<String> currencies;
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterError)
          HelperFunctions.showMessage(context, state.errorMessage, Colors.red);
        if (state is RegisterLoading)
          HelperFunctions.showMessage(
              context, 'Loading register form...', Colors.green);
        if (state is RegisterSending)
          HelperFunctions.showMessage(
              context, 'Sending the registration...', Colors.green);
        if (state is RegisterSuccess) {
          BlocProvider.of<AuthBloc>(context)
              .add(UpdateAuth(state.authenticate));
          if (authenticate?.company?.partyId != null) {
            Navigator.pop(
                context,
                'Register successfull,' +
                    ' you can now login with your email password');
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, HomeRoute, ModalRoute.withName(HomeRoute),
                arguments: "Register Company and admin successfull\n"
                    "you can now login at the top right corner\n"
                    "with your email password.");
          }
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        if (state is AuthUnauthenticated) authenticate = state.authenticate;
        return BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
          if (state is RegisterLoading || state is RegisterSending)
            return Center(child: CircularProgressIndicator());
          if (state is RegisterLoaded) {
            currencies = state?.currencies;
            _currencySelected = _currencySelected ?? currencies[0];
          }
          return Center(
              child: Container(
                  width: 400,
                  child: Form(
                      key: _formKey,
                      child: ListView(children: <Widget>[
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
                        Text('A temporary password will be send by email',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.orange,
                            )),
                        SizedBox(height: 10),
                        TextFormField(
                          key: Key('email'),
                          decoration:
                              InputDecoration(labelText: 'Email address'),
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
                        Visibility(
                            visible: authenticate?.company?.partyId != null,
                            child: Column(children: [
                              SizedBox(height: 20),
                              RaisedButton(
                                  key: Key('newCustomer'),
                                  child: Text('Register as a customer'),
                                  onPressed: () {
                                    String _currencyAbr =
                                        _currencySelected.substring(
                                            _currencySelected.indexOf('[') + 1);
                                    _currencyAbr = _currencyAbr.substring(
                                        0, _currencyAbr.indexOf(']'));
                                    if (_formKey.currentState.validate() &&
                                        state is! RegisterSending)
                                      BlocProvider.of<RegisterBloc>(context)
                                          .add(
                                        RegisterButtonPressed(
                                          companyPartyId:
                                              authenticate?.company?.partyId,
                                          firstName: _firstNameController.text,
                                          lastName: _lastNameController.text,
                                          email: _emailController.text,
                                        ),
                                      );
                                  })
                            ])),
                        SizedBox(height: 20),
                        Visibility(
                            // register new company and admin
                            visible: authenticate?.company?.partyId == null,
                            child: Column(children: [
                              SizedBox(height: 10),
                              TextFormField(
                                key: Key('companyName'),
                                decoration:
                                    InputDecoration(labelText: 'Business name'),
                                controller: _companyController,
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Please enter business name?';
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
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
                                child: DropdownButton(
                                  key: Key('dropDown'),
                                  underline: SizedBox(), // remove underline
                                  hint: Text('Currency'),
                                  value: _currencySelected,
                                  items: currencies == null
                                      ? null
                                      : currencies
                                          .map((value) => DropdownMenuItem(
                                                child: Text(value),
                                                value: value,
                                              ))
                                          .toList(),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _currencySelected = newValue;
                                    });
                                  },
                                  isExpanded: true,
                                ),
                              ),
                              SizedBox(height: 20),
                              RaisedButton(
                                  key: Key('newCompany'),
                                  child: Text(
                                      'Register AND create a new Ecommerce shop'),
                                  onPressed: () {
                                    String _currencyAbr =
                                        _currencySelected.substring(
                                            _currencySelected.indexOf('[') + 1);
                                    _currencyAbr = _currencyAbr.substring(
                                        0, _currencyAbr.indexOf(']'));
                                    if (_formKey.currentState.validate() &&
                                        state is! RegisterSending)
                                      BlocProvider.of<RegisterBloc>(context)
                                          .add(
                                        RegisterCompanyAdmin(
                                          companyName: _companyController.text,
                                          currency: _currencyAbr,
                                          firstName: _firstNameController.text,
                                          lastName: _lastNameController.text,
                                          email: _emailController.text,
                                        ),
                                      );
                                  }),
                            ]))
                      ]))));
        });
      }),
    );
  }
}
