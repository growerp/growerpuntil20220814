import 'package:about/about.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/@widgets.dart';

class AboutForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FormHeader(AboutFormHeader(), 4);
  }
}

class AboutFormHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double version = GlobalConfiguration().get("version");
    double build = GlobalConfiguration().get("build");

    return AboutPage(
        dialog: true,
        title: Text('About GrowERP and this Admin app'),
        applicationVersion: 'Version $version, build #$build',
        applicationIcon: Image(
          image: AssetImage('assets/growerp.png'),
          height: 100,
          width: 200,
        ),
        applicationLegalese: '© GrowERP, {{ year }}',
        children: <Widget>[
          Center(
              child: Container(
                  width: 300,
                  child: Form(
                      child: Column(
                    children: <Widget>[
                      MarkdownPageListTile(
                        filename: 'README.md',
                        title: Text('View Readme'),
                        icon: Icon(Icons.all_inclusive),
                      ),
                      MarkdownPageListTile(
                        filename: 'CHANGELOG.md',
                        title: Text('View Changelog'),
                        icon: Icon(Icons.view_list),
                      ),
                      MarkdownPageListTile(
                        filename: 'LICENSE.md',
                        title: Text('View License'),
                        icon: Icon(Icons.description),
                      ),
                      MarkdownPageListTile(
                        filename: 'CONTRIBUTING.md',
                        title: Text('Contributing'),
                        icon: Icon(Icons.share),
                      ),
                      MarkdownPageListTile(
                        filename: 'CODE_OF_CONDUCT.md',
                        title: Text('Privacy, Code of conduct'),
                        icon: Icon(Icons.sentiment_satisfied),
                      ),
                      LicensesPageListTile(
                        title: Text('Open source Licenses'),
                        icon: Icon(Icons.favorite),
                      ),
                    ],
                  ))))
        ]);
  }
}
