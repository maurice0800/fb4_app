import 'package:fb4_app/areas/more/screens/licenses_page.dart';
import 'package:fb4_app/areas/more/screens/links_downloads_page.dart';
import 'package:fb4_app/areas/more/screens/privacy_page.dart';
import 'package:fb4_app/areas/more/screens/settings_page.dart';
import 'package:fb4_app/areas/more/viewmodels/privacy_page_viewmodel.dart';
import 'package:fb4_app/areas/ods/viewmodels/grades_overview_page_viewmodel.dart';
import 'package:fb4_app/areas/ods/views/grade_overview_page.dart';
import 'package:fb4_app/areas/ods/views/login_page.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kiwi/kiwi.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreListPage extends StatelessWidget {
  const MoreListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: ColorConsts.mainOrange,
          transitionBetweenRoutes: false,
          middle: Text("Mehr",
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
        ),
        child: CupertinoSettings(items: <Widget>[
          const CSHeader("Mehr"),
          CSLink(
            title: 'Links / Downloads',
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => const LinksDownloadsPage()));
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
                  builder: (context) => const SettingsPage()));
            },
          ),
          CSLink(
            title: 'Über',
            onPressed: () => showAboutDialog(context),
          ),
          CSLink(
            title: "Lizenzen",
            onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const LicensesPage(),
                )),
          ),
          CSLink(
            title: "Datenschutz",
            onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                          create: (context) => PrivacyPageViewModel()..load(),
                          child: const PrivacyPage(),
                        ))),
          ),
          const CSHeader("Mobiles ODS"),
          CSLink(
            title: "Notenübersicht",
            onPressed: () async {
              if (await const FlutterSecureStorage()
                      .containsKey(key: 'odsUsername') ||
                  KiwiContainer()
                      .resolve<GradeOverviewPageViewModel>()
                      .exams
                      .isNotEmpty) {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => GradeOverViewPage()),
                );
              } else {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const LoginPage()));
              }
            },
          ),
        ]));
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
              color: CupertinoTheme.of(context).primaryContrastingColor),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: 600,
                maxWidth: MediaQuery.of(context).size.width - 80),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const Text("Über diese App",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Divider(
                        color: ColorConsts.mainOrange,
                        thickness: 2,
                      ),
                    ),
                    const Text(
                      "Fachschaftsrat Informatik",
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "FB4",
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    const Text("Version: 1.2.0"),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Divider(
                        color: ColorConsts.mainOrange,
                        thickness: 2,
                      ),
                    ),
                    CupertinoButton(
                        child: const Text(
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
      )),
    );
  }
}
