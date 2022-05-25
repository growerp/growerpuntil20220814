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

import 'package:core/domains/common/functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domains/domains.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../api_repository.dart';

class WebsiteForm extends StatelessWidget {
  final Key? key;
  final UserGroup userGroup;
  const WebsiteForm({
    this.key,
    required this.userGroup,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          WebsiteBloc(context.read<APIRepository>())..add(WebsiteFetch()),
      child: WebsitePage(),
    );
  }
}

class WebsitePage extends StatefulWidget {
  @override
  _WebsiteState createState() => _WebsiteState();
}

class _WebsiteState extends State<WebsitePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WebsiteBloc, WebsiteState>(listener: (context, state) {
      switch (state.status) {
        case WebsiteStatus.success:
          HelperFunctions.showMessage(
              context, '${state.message}', Colors.green);
          break;
        case WebsiteStatus.failure:
          HelperFunctions.showMessage(context, '${state.message}', Colors.red);
          break;
        default:
      }
    }, builder: (context, state) {
      switch (state.status) {
        case WebsiteStatus.failure:
          return Center(
              child: Text('failed to fetch website info ${state.message}'));
        case WebsiteStatus.success:
          _titleController.text.isEmpty
              ? _titleController.text = state.website?.title ?? ''
              : '';
          return ScaffoldMessenger(
              key: scaffoldMessengerKey,
              child: Scaffold(body: Center(child: _showForm(state))));
        default:
          return LoadingIndicator();
      }
    });
  }

  Widget _showForm(WebsiteState state) {
    bool isPhone = ResponsiveWrapper.of(context).isSmallerThan(TABLET);
    return Center(
        child: Container(
            width: 400,
            child: SingleChildScrollView(
                key: Key('listView'),
                child: Form(
                    key: _formKey,
                    child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(children: [
                          Center(
                              child: Text(
                            'id:#${state.website?.id}',
                            style: TextStyle(
                                fontSize: isPhone ? 10 : 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            key: Key('header'),
                          )),
                          SizedBox(height: 10),
                          Center(
                              child: Text(
                            "url: ${state.website?.hostName}",
                            style: TextStyle(
                                fontSize: isPhone ? 20 : 30,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            key: Key('header'),
                          )),
                          SizedBox(height: 10),
                          TextFormField(
                            key: Key('websiteTitle'),
                            decoration:
                                InputDecoration(labelText: 'Website Title'),
                            controller: _titleController,
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Please enter the website Title?';
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                              key: Key('update'),
                              child: Text(
                                'Update',
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  context.read<WebsiteBloc>().add(WebsiteUpdate(
                                      state.website!.copyWith(
                                          title: _titleController.text)));
                                }
                              })
                        ]))))));
  }
}
