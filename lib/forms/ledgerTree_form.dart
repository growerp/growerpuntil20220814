import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';

class LedgerTreeForm extends StatefulWidget {
  @override
  _LedgerTreeFormState createState() => _LedgerTreeFormState();
}

class _LedgerTreeFormState extends State<LedgerTreeForm> {
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
