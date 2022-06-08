import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_widget/markdown_widget.dart';
import '../../common/functions/helper_functions.dart';
import '../../domains.dart';

class EditorDialog extends StatefulWidget {
  final String websiteId;
  final Content content;
  EditorDialog(this.websiteId, this.content);
  @override
  State<EditorDialog> createState() => _MarkdownPageState();
}

class _MarkdownPageState extends State<EditorDialog> {
  late String data;

  @override
  void initState() {
    data = widget.content.text.isEmpty
        ? 'Enter ${widget.content.id} text here'
        : widget.content.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        key: Key('EditorDialog'),
        insetPadding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(clipBehavior: Clip.none, children: [
              _showForm(),
              Positioned(top: 5, right: 5, child: DialogCloseButton()),
            ])));
  }

  Widget _showForm() {
    return BlocListener<WebsiteBloc, WebsiteState>(
        listener: (context, state) {
          if (state.status == WebsiteStatus.success)
            Navigator.of(context).pop();
          if (state.status == WebsiteStatus.failure)
            HelperFunctions.showMessage(context, state.message, Colors.red);
        },
        child: Container(
            width: 400,
            height: 800,
            padding: EdgeInsets.all(20),
            child: Column(children: [
              Expanded(
                  child: TextFormField(
                      decoration: InputDecoration(
                          labelText: '${widget.content.id} text'),
                      expands: true,
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                      initialValue: data,
                      onChanged: (text) {
                        setState(() {
                          data = text;
                        });
                      })),
              SizedBox(height: 20),
              Expanded(child: MarkdownWidget(data: data)),
              SizedBox(height: 20),
              ElevatedButton(
                  key: Key('update'),
                  child: Text('Update'),
                  onPressed: () async {
                    if (data != widget.content.text)
                      context.read<WebsiteBloc>().add(WebsiteUpdate(Website(
                              id: widget.websiteId,
                              websiteContent: [
                                widget.content.copyWith(text: data)
                              ])));
                    else
                      Navigator.of(context).pop(data);
                  }),
            ])));
  }
}
