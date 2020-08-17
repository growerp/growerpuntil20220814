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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/@bloc.dart';
import '../models/@models.dart';
import '../helper_functions.dart';
import '../routing_constants.dart';

class HomeForm extends StatelessWidget {
  final String message;
  const HomeForm({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeBody(message: message),
    );
  }
}

class HomeBody extends StatefulWidget {
  final String message;

  const HomeBody({Key key, this.message}) : super(key: key);
  @override
  State<HomeBody> createState() => _HomeState(message);
}

class _HomeState extends State<HomeBody> {
  final String message;
  Authenticate authenticate;
  Company company;

  _HomeState(this.message);

  @override
  void initState() {
    Future<Null>.delayed(Duration(milliseconds: 0), () {
      if (message != null) {
        HelperFunctions.showMessage(context, '$message', Colors.green);
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthConnectionProblem) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: RaisedButton(
                    child: Text("${state.errorMessage} \nRetry?"),
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(LoadAuth());
                    }),
              )
            ]);
      }
      if (state is AuthAuthenticated) authenticate = state.authenticate;
      if (state is AuthUnauthenticated) authenticate = state.authenticate;
      company = authenticate?.company;
      return Scaffold(
          appBar: AppBar(
              title: Text("${company?.name ?? 'Company??'} " +
                  "${authenticate?.apiKey != null ? "- username: " + authenticate?.user?.name : ''}"),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.settings),
                    tooltip: 'Settings',
                    onPressed: () async {
                      await _settingsDialog(context, authenticate);
                    }),
                if (authenticate?.apiKey == null)
                  IconButton(
                      icon: Icon(Icons.exit_to_app),
                      tooltip: 'Login',
                      onPressed: () async {
                        if (await Navigator.pushNamed(context, LoginRoute) ==
                            true) {
                          Navigator.popAndPushNamed(context, HomeRoute,
                              arguments: 'Login Successful');
                        } else {
                          HelperFunctions.showMessage(
                              context, 'Not logged in', Colors.green);
                        }
                      }),
                if (authenticate?.apiKey != null)
                  IconButton(
                      icon: Icon(Icons.do_not_disturb),
                      tooltip: 'Logout',
                      onPressed: () => {
                            BlocProvider.of<AuthBloc>(context).add(Logout()),
                            Future<Null>.delayed(Duration(milliseconds: 300),
                                () {
                              Navigator.popAndPushNamed(context, HomeRoute,
                                  arguments: 'Logout successful');
                            })
                          })
              ]),
          body: Center(child: Text('Home screen')));
    });
  }

  _settingsDialog(BuildContext context, Authenticate authenticate) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Text('Settings', textAlign: TextAlign.center),
            content: Container(
              height: 200,
              child: Column(children: <Widget>[
                RaisedButton(
                  child: Text('Select an another company'),
                  onPressed: () async {
                    authenticate.company.partyId = null;
                    BlocProvider.of<AuthBloc>(context)
                        .add(UpdateAuth(authenticate));
                    Navigator.popAndPushNamed(context, LoginRoute);
                  },
                ),
                SizedBox(height: 20),
                RaisedButton(
                  child: Text('Create a new company and admin'),
                  onPressed: () {
                    authenticate.company.partyId = null;
                    BlocProvider.of<AuthBloc>(context)
                        .add(UpdateAuth(authenticate));
                    Navigator.popAndPushNamed(context, RegisterRoute);
                  },
                ),
                SizedBox(height: 20),
                RaisedButton(
                  child: Text('About'),
                  onPressed: () {
                    Navigator.popAndPushNamed(context, AboutRoute);
                  },
                ),
              ]),
            ));
      },
    );
  }
}
