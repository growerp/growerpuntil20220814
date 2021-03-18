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
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';

class IncomeStatementForm extends StatefulWidget {
  @override
  _IncomeStatementFormState createState() => _IncomeStatementFormState();
}

class _IncomeStatementFormState extends State<IncomeStatementForm> {
  final Key _key = ValueKey(22);
  final TreeController _controller = TreeController(allNodesExpanded: true);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 300,
          width: 300,
          child: buildTree(),
        ),
        ElevatedButton(
          child: Text("Expand All"),
          onPressed: () => setState(() {
            _controller.expandAll();
          }),
        ),
        ElevatedButton(
          child: Text("Collapse All"),
          onPressed: () => setState(() {
            _controller.collapseAll();
          }),
        ),
        ElevatedButton(
          child: Text("Expand node 22"),
          onPressed: () => setState(() {
            _controller.expandNode(_key);
          }),
        ),
        ElevatedButton(
          child: Text("Collapse node 22"),
          onPressed: () => setState(() {
            _controller.collapseNode(_key);
          }),
        ),
      ],
    );
  }

  Widget buildTree() {
    return TreeView(
      treeController: _controller,
      nodes: [
        TreeNode(content: Text("node 1")),
        TreeNode(
          content: Icon(Icons.audiotrack),
          children: [
            TreeNode(content: Text("node 21")),
            TreeNode(
              content: Text("node 22"),
              key: _key,
              children: [
                TreeNode(
                  content: Icon(Icons.sentiment_very_satisfied),
                ),
              ],
            ),
            TreeNode(
              content: Text("node 23"),
            ),
          ],
        ),
      ],
    );
  }
}
