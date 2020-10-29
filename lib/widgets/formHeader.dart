import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/@blocs.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../models/@models.dart';
import '@widgets.dart';

class FormHeader extends StatelessWidget {
  final Widget widget;
  const FormHeader(this.widget);
  @override
  Widget build(BuildContext context) {
    Authenticate authenticate;
    bool loggedIn = false;
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthUnauthenticated) authenticate = state.authenticate;
      if (state is AuthLoading)
        return Center(child: CircularProgressIndicator());
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
      }
      if (state is AuthAuthenticated) {
        loggedIn = true;
        authenticate = state.authenticate;
      }

      return loggedIn && !ResponsiveWrapper.of(context).isSmallerThan(TABLET)
          ? myNavigationRail(context, authenticate, widget)
          : widget;
    });
  }
}
