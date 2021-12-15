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
import 'package:printing/printing.dart';
import 'package:core/domains/domains.dart';

class PrintingForm extends StatelessWidget {
  final FormArguments formArguments;
  const PrintingForm({Key? key, required this.formArguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrintingPage(finDocIn: formArguments.object as FinDoc);
  }
}

class PrintingPage extends StatelessWidget {
  final FinDoc finDocIn;
  const PrintingPage({Key? key, required this.finDocIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Authenticate authenticate;

    var repos = context.read<Object>();
    return BlocProvider<FinDocBloc>(
        create: (context) => FinDocBloc(repos, finDocIn.sales, finDocIn.docType)
          ..add(
              FinDocFetch(finDocId: finDocIn.id()!, docType: finDocIn.docType)),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          if (state.status == AuthStatus.authenticated)
            authenticate = state.authenticate!;
          return BlocBuilder<FinDocBloc, FinDocState>(
              builder: (context, state) {
            switch (state.status) {
              case FinDocStatus.failure:
                return Center(
                    child: Text('failed to fetch findocs: ${state.message}'));
              case FinDocStatus.success:
                return Stack(children: [
                  PdfPreview(
                    build: (format) => PdfFormats.finDocPdf(
                        format, authenticate.company!, finDocIn),
                  ),
                  ElevatedButton(
                      key: Key('back'),
                      child: Text('Back'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ]);
              default:
                return const Center(child: CircularProgressIndicator());
            }
          });
        }));
  }
}
