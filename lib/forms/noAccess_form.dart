import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/@blocs.dart';

class NoAccessForm extends StatelessWidget {
  final String name;
  const NoAccessForm(this.name);
  @override
  Widget build(BuildContext context) {
    String message;
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthUnauthenticated) {
        message =
            "You are not logged in to company: ${state.authenticate.company.name}";
      }
      return Scaffold(
        body: Center(
          child: Text(message != null ? message : 'No access to $name form'),
        ),
      );
    });
  }
}
