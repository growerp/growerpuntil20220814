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

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/@blocs.dart';
import '../models/@models.dart';
import '../helper_functions.dart';
import '../routing_constants.dart';
import '@forms.dart';

class MasterHome extends StatelessWidget {
  final String message;
  MasterHome(this.message);

  @override
  Widget build(BuildContext context) {
    Authenticate authenticate;
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) authenticate = state.authenticate;
      if (state is AuthUnauthenticated) authenticate = state.authenticate;
      if (state is AuthProblem) {
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
      } else
        return Scaffold(
            appBar: AppBar(
                title: Text("${authenticate?.company?.name ?? 'Company??'} " +
                    "${authenticate?.user != null ? ", user: ${authenticate?.user?.firstName} ${authenticate?.user?.lastName}" : ''}"),
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
            body: BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthProblem) {
                    HelperFunctions.showMessage(
                        context, '${state.errorMessage}', Colors.red);
                  }
                },
                child: MasterHomeBody(authenticate, message)));
    });
  }
}

class MasterHomeBody extends StatefulWidget {
  final Authenticate authenticate;
  final String message;
  MasterHomeBody(this.authenticate, this.message);
  @override
  State<MasterHomeBody> createState() => _HomeState(authenticate, message);
}

class _HomeState extends State<MasterHomeBody> {
  final Authenticate authenticate;
  final String message;
  ContainerTransitionType _transitionType = ContainerTransitionType.fadeThrough;
  _HomeState(this.authenticate, this.message);

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
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: <Widget>[
        _OpenContainerWrapper(
          targetForm: DetailForm(),
          transitionType: _transitionType,
          closedBuilder: (BuildContext _, VoidCallback openContainer) {
            return TopCard(openContainer: openContainer);
          },
        ),
        const SizedBox(height: 16.0),
        Row(
          children: <Widget>[
            Expanded(
              child: _OpenContainerWrapper(
                targetForm: AboutForm(),
                transitionType: _transitionType,
                closedBuilder: (BuildContext _, VoidCallback openContainer) {
                  return MenuCard(
                    openContainer: openContainer,
                    image: 'assets/about.png',
                    subtitle: 'About',
                  );
                },
              ),
            ),
            Expanded(
              child: _OpenContainerWrapper(
                targetForm: CompanyForm(),
                transitionType: _transitionType,
                closedBuilder: (BuildContext _, VoidCallback openContainer) {
                  return MenuCard(
                    openContainer: openContainer,
                    image: 'assets/company.png',
                    subtitle: 'Company',
                  );
                },
              ),
            ),
            Expanded(
              child: _OpenContainerWrapper(
                targetForm: UserForm(widget.authenticate?.user),
                transitionType: _transitionType,
                closedBuilder: (BuildContext _, VoidCallback openContainer) {
                  return MenuCard(
                    openContainer: openContainer,
                    image: 'assets/personInfo.png',
                    subtitle: 'My Info',
                  );
                },
              ),
            ),
            Expanded(
              child: _OpenContainerWrapper(
                targetForm: UsersForm(),
                transitionType: _transitionType,
                closedBuilder: (BuildContext _, VoidCallback openContainer) {
                  return MenuCard(
                    openContainer: openContainer,
                    image: 'assets/users.png',
                    subtitle: 'Users',
                  );
                },
              ),
            ),
            const SizedBox(width: 8.0),
          ],
        ),
      ],
    );
  }
}

class _OpenContainerWrapper extends StatelessWidget {
  final Widget targetForm;
  final OpenContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  const _OpenContainerWrapper({
    this.closedBuilder,
    this.transitionType,
    this.targetForm,
  });

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return targetForm;
      },
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}

class TopCard extends StatelessWidget {
  final VoidCallback openContainer;
  const TopCard({this.openContainer});

  @override
  Widget build(BuildContext context) {
    return _InkWellOverlay(
        openContainer: openContainer,
//        height: 500,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: <Widget>[
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: InkWell(
                    child: Text(
                        '\n\nThis app is the basis and contains\n'
                        'the functions which are used\n'
                        'in most other apps.\n'
                        'Click for a function list at the Readme\n\n'
                        '\n\nMulticompany App\n'
                        'Create a new company at setup (top right) to test&try'
                        '\n\n\nHome Page for a Dashboard\n\n\n\n\n'
                        'Page Selection below\n\n\n\n\n',
                        textAlign: TextAlign.center),
                    onTap: () => Navigator.pushNamed(context, AboutRoute),
                  )))
            ])));
  }
}

class MenuCard extends StatelessWidget {
  final VoidCallback openContainer;
  final String image;
  final String subtitle;

  const MenuCard({
    this.openContainer,
    this.image,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return _InkWellOverlay(
      openContainer: openContainer,
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[Image.asset(image), Text(subtitle)],
      ),
    );
  }
}

class _InkWellOverlay extends StatelessWidget {
  final bool needsLogin;
  final VoidCallback openContainer;
  final double width;
  final double height;
  final Widget child;

  const _InkWellOverlay({
    this.needsLogin = true,
    this.openContainer,
    this.width,
    this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: InkWell(
        onTap: openContainer,
        child: child,
      ),
    );
  }
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
            ]),
          ));
    },
  );
}
