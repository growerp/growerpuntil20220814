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

import 'package:core/domains/accounting/blocs/glAccount_bloc.dart';
import 'package:core/domains/accounting/models/glAccount_model.dart';
import 'package:core/domains/common/functions/helper_functions.dart';
import 'package:core/domains/common/views/fatalError_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class LedgerTreeForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          GlAccountBloc(context.read<Object>())..add(GlAccountFetch()),
      child: LedgerTreeListForm(),
    );
  }
}

class LedgerTreeListForm extends StatefulWidget {
  @override
  _LedgerTreeFormState createState() => _LedgerTreeFormState();
}

class _LedgerTreeFormState extends State<LedgerTreeListForm> {
  TreeController? _controller;
  Iterable<TreeNode> nodes = [];

  @override
  void initState() {
    super.initState();
    _controller = TreeController(allNodesExpanded: false);
    BlocProvider.of<GlAccountBloc>(context)..add(GlAccountFetch());
  }

  @override
  Widget build(BuildContext context) {
    bool isPhone = ResponsiveWrapper.of(context).isSmallerThan(TABLET);
    //convert glAccount list into TreeNodes
    Iterable<TreeNode> convert(List<GlAccount> glAccounts) {
      // convert single leaf/glAccount
      TreeNode getTreeNode(GlAccount glAccount) {
        // recursive function
        TreeNode result = TreeNode(
          key: ValueKey(glAccount.id),
          content: Row(children: [
            SizedBox(
                width: (isPhone ? 210 : 400) - (glAccount.l!.toDouble() * 10),
                child: Text("${glAccount.id} ${glAccount.accountName} ")),
            SizedBox(
                width: 100,
                child: Text(
                    NumberFormat.simpleCurrency()
                        .format(glAccount.postedBalance),
                    textAlign: TextAlign.right)),
            SizedBox(
                width: 100,
                child: Text(
                    NumberFormat.simpleCurrency().format(glAccount.rollUp),
                    textAlign: TextAlign.right))
          ]),
          children: glAccount.children!.map((x) => getTreeNode(x)).toList(),
        );
        return result;
      }

      // main: do the actual conversion
      List<TreeNode> treeNodes = [];
      glAccounts.forEach((element) {
        treeNodes.add(getTreeNode(element));
      });
      Iterable<TreeNode> iterable = treeNodes;
      return iterable;
    }

    return BlocConsumer<GlAccountBloc, GlAccountState>(
        listener: (context, state) {
      if (state.status == GlAccountStatus.failure)
        HelperFunctions.showMessage(context, '${state.message}', Colors.red);
    }, builder: (context, state) {
      if (state.status == GlAccountStatus.failure)
        return FatalErrorForm("Could not load Ledger tree!");
      if (state.status == GlAccountStatus.success)
        nodes = convert(state.glAccounts);
      return ListView(
        children: <Widget>[
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            ElevatedButton(
              child: Text("Expand All"),
              onPressed: () => setState(() {
                _controller!.expandAll();
              }),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              child: Text("Collapse All"),
              onPressed: () => setState(() {
                _controller!.collapseAll();
              }),
            ),
          ]),
          SizedBox(height: 10),
          Row(children: [
            SizedBox(width: 20),
            SizedBox(
                width: isPhone ? 220 : 410,
                child: Text("Gl Account ID  GL Account Name")),
            SizedBox(
                width: 100, child: Text("Posted", textAlign: TextAlign.right)),
            SizedBox(
                width: 100, child: Text("Roll Up", textAlign: TextAlign.right))
          ]),
          Divider(color: Colors.black),
          TreeView(
            treeController: _controller,
            nodes: nodes as List<TreeNode>,
            indent: 10,
          )
        ],
      );
    });
  }
}
