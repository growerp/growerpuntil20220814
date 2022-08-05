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

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:core/domains/domains.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/functions/functions.dart';

class FilesDialog extends StatefulWidget {
  final Object object;

  const FilesDialog(this.object);
  @override
  State<FilesDialog> createState() => _FilesHeaderState();
}

class _FilesHeaderState extends State<FilesDialog> {
  late CategoryBloc _categoryBloc;
  @override
  void initState() {
    _categoryBloc = BlocProvider.of<CategoryBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
      switch (state.status) {
        case CategoryStatus.success:
          Navigator.of(context).pop();
          break;
        case CategoryStatus.failure:
          HelperFunctions.showMessage(
              context, 'Error: ${state.message}', Colors.red);
          break;
        default:
      }
    }, builder: (context, state) {
      return Stack(children: [
        PopUpDialog(
            context: context,
            title: "Category Up/Download",
            child: SingleChildScrollView(
                child: Column(children: [
              SizedBox(height: 40),
              Text("Download first to obtain the format"),
              SizedBox(height: 10),
              ElevatedButton(
                  key: Key('upload'),
                  child: Text('Upload CSV file'),
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                            allowedExtensions: ['csv'], type: FileType.custom);
                    if (result != null) {
                      File file = File(result.files.single.path ?? '');
                      _categoryBloc.add(CategoryUpload(file));
                    }
                  }),
              SizedBox(height: 20),
              ElevatedButton(
                  key: Key('download'),
                  child: Text('Download via email'),
                  onPressed: () {
                    _categoryBloc.add(CategoryDownload());
                  }),
              SizedBox(height: 20),
              Text("A data file will be send by email"),
            ]))),
        if (state.status == CategoryStatus.loading) LoadingIndicator(),
      ]);
    });
  }
}
