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
import '../blocs/@blocs.dart';
import '../models/@models.dart';
import '../helper_functions.dart';
import '../routing_constants.dart';
import '../widgets/@widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AdminHome extends StatelessWidget {
  final String message;
  AdminHome(this.message);

  @override
  Widget build(BuildContext context) {
    var a = (message) => (DashBoard(message));
    return FormHeader(a(message));
  }
}

class DashBoard extends StatelessWidget {
  final String message;
  const DashBoard(this.message);
  @override
  Widget build(BuildContext context) {
    Authenticate authenticate;
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) {
        authenticate = state.authenticate;
        return Scaffold(
            appBar: AppBar(
                title: Text("${authenticate?.company?.name ?? 'Company??'}"),
                actions: <Widget>[
                  if (authenticate?.apiKey != null)
                    IconButton(
                        icon: Icon(Icons.do_not_disturb),
                        tooltip: 'Logout',
                        onPressed: () => {
                              BlocProvider.of<AuthBloc>(context).add(Logout()),
                              BlocProvider.of<AuthBloc>(context).add(LoadAuth())
                            })
                ]),
            drawer: myDrawer(context, authenticate),
            body: BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthProblem) {
                    HelperFunctions.showMessage(
                        context, '${state.errorMessage}', Colors.red);
                  }
                  if (state is AuthLoading) {
                    HelperFunctions.showMessage(
                        context, 'Loading data', Colors.green);
                  }
                  if (state is AuthAuthenticated) {
                    HelperFunctions.showMessage(
                        context, '${state.message}', Colors.green);
                  }
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
                  child: GridView.count(
                    crossAxisCount:
                        ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                            ? 2
                            : 3,
                    padding: EdgeInsets.all(3.0),
                    children: <Widget>[
                      makeDashboardItem("Ordbog", Icons.book),
                      makeDashboardItem("Alphabet", Icons.alarm),
                      makeDashboardItem("Alphabet", Icons.alarm),
                      makeDashboardItem("Alphabet", Icons.alarm),
                      makeDashboardItem("Alphabet", Icons.alarm),
                      makeDashboardItem("Alphabet", Icons.alarm)
                    ],
                  ),
                )));
      }
      if (state is AuthUnauthenticated) {
        authenticate = state.authenticate;
        return Scaffold(
            appBar: AppBar(
                title: Text("${authenticate?.company?.name ?? 'Company??'}")),
            body: Center(
                child: Column(children: <Widget>[
              SizedBox(height: 150),
              Text("Login to an existing company"),
              RaisedButton(
                child: Text('Login'),
                onPressed: () {
                  Navigator.pushNamed(context, LoginRoute);
                },
              ),
              SizedBox(height: 50),
              Text("Or create a new company and you being the administrator"),
              RaisedButton(
                child: Text('Create a new company and admin'),
                onPressed: () {
                  authenticate.company.partyId = null;
                  BlocProvider.of<AuthBloc>(context)
                      .add(UpdateAuth(authenticate));
                  Navigator.popAndPushNamed(context, RegisterRoute);
                },
              ),
            ])));
      }
      return (Center(child: Container(child: Text("????"))));
    });
  }
}

Card makeDashboardItem(String title, IconData icon) {
  return Card(
      elevation: 1.0,
      margin: new EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, 1.0)),
        child: new InkWell(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              SizedBox(height: 50.0),
              Center(
                  child: Icon(
                icon,
                size: 40.0,
                color: Colors.black,
              )),
              SizedBox(height: 20.0),
              new Center(
                child: new Text(title,
                    style: new TextStyle(fontSize: 18.0, color: Colors.black)),
              )
            ],
          ),
        ),
      ));
}
