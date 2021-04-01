import 'package:fb4_app/areas/more/screens/links_downloads_page.dart';
import 'package:fb4_app/areas/more/screens/settings_page.dart';
import 'package:fb4_app/areas/more/viewmodels/settings_page_view_model.dart';
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
            CSLink(
              title: 'Über',
              onPressed: () => showAboutDialog(context),
            ),
          ]),
        ));
  }

  void showAboutDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CupertinoPopupSurface(
          child: Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: CupertinoColors.white),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: 600,
                maxWidth: MediaQuery.of(context).size.width - 80),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Container(
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Text("Über diese App",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.black,
                              fontSize: 18)),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Divider(
                          color: ColorConsts.mainOrange,
                          thickness: 2,
                        ),
                      ),
                      Text(
                        "Fachschaftsrat Informatik",
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "FB4",
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: 10),
                      Text("Version: 1.0.0 BETA"),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Divider(
                          color: ColorConsts.mainOrange,
                          thickness: 2,
                        ),
                      ),
                      CupertinoButton(
                          child: Text(
                            "Schließen",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }
}
