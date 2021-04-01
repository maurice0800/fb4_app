import 'package:fb4_app/areas/more/screens/links_downloads_page.dart';
import 'package:fb4_app/areas/more/screens/settings_page.dart';
import 'package:fb4_app/areas/more/viewmodels/settings_page_view_model.dart';
import 'package:fb4_app/areas/more/widgets/list_item.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreList extends StatelessWidget {
  const MoreList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: ColorConsts.mainOrange,
          transitionBetweenRoutes: false,
          middle: Text("Mehr",
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
        ),
        child: Container(
          child: CupertinoSettings(items: <Widget>[
            CSLink(
              title: 'Links / Downloads',
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => LinksDownloadsPage()));
              },
            ),
            CSLink(
              title: 'Feedback geben',
              onPressed: () {
                launch("mailto:fb4app@hemacode.de");
              },
            ),
            CSLink(
              title: 'Einstellungen',
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                          create: (context) => SettingsPageViewModel()..init(),
                          child: SettingsPage(),
                        )));
              },
            ),
            CSLink(title: 'Über'),
          ]),
        ));
  }
}
