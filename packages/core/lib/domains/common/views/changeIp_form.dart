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

import 'package:core/domains/domains.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeIpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String ip = '', companyPartyId = '', chat = '';
    return Scaffold(
      body: Center(
          child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Text('Enter a backend && chat url in the form of: xxx.yyy.zzz',
            textAlign: TextAlign.center),
        content: Container(
            height: 200,
            child: Column(children: <Widget>[
              TextFormField(
                  autofocus: true,
                  decoration: new InputDecoration(labelText: 'Backend server:'),
                  onChanged: (value) {
                    ip = value;
                  }),
              SizedBox(height: 10),
              TextFormField(
                  autofocus: true,
                  decoration: new InputDecoration(labelText: 'Chat server:'),
                  onChanged: (value) {
                    chat = value;
                  }),
              SizedBox(height: 10),
              TextFormField(
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: 'partyId of main company:'),
                  onChanged: (value) {
                    companyPartyId = value;
                  })
            ])),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Cancel'),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLoad());
            },
          ),
          ElevatedButton(
            child: Text('Ok'),
            onPressed: () async {
              if (ip.isNotEmpty) {
                if (!ip.startsWith('https://')) ip = 'https://$ip';
                if (!ip.endsWith('/')) ip = '$ip/';
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('ip', ip);
              }
              if (chat.isNotEmpty) {
                if (!chat.startsWith('wss://')) chat = 'wss://$chat';
                if (!chat.endsWith('/')) chat = '$chat/';
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('chat', chat);
              }
              if (companyPartyId.isNotEmpty) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('companyPartyId', companyPartyId);
              }
              context.read<AuthBloc>().add(AuthLoad());
            },
          ),
        ],
      )),
    );
  }
}
