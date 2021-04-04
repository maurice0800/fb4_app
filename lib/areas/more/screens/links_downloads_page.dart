import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
import 'package:url_launcher/url_launcher.dart';

class LinksDownloadsPage extends StatelessWidget {
  const LinksDownloadsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: ColorConsts.mainOrange,
        middle: Text("Links / Downloads"),
      ),
      child: CupertinoSettings(
        items: [
          CSHeader("Links"),
          CSLink(
            title: "Studierbar",
            onPressed: () => launch("https://www.studierbar.de"),
          ),
          CSLink(
            title: "Ilias",
            onPressed: () => launch("https://ilias.fh-dortmund.de"),
          ),
          CSLink(
            title: "ODS",
            onPressed: () => launch("https://ods.fh-dortmund.de"),
          ),
          CSLink(
            title: "SmartAssign",
            onPressed: () => launch("https://smartassign.inf.fh-dortmund.de"),
          ),
          CSLink(
            title: "FH Dortmund",
            onPressed: () => launch("https://www.fh-dortmund.de"),
          ),
          CSLink(
            title: "Fachschaftsrat Informatik",
            onPressed: () => launch("https://www.fsrfb4.de"),
          ),
          CSLink(
            title: "E-Mail",
            onPressed: () =>
                launch("https://studwebmailer.fh-dortmund.de/gw/webacc"),
          ),
          CSHeader("Downloads"),
          CSLink(
            title: "Prüfungsplan",
            onPressed: () => launch("https://www.fh-dortmund.de/zeitplan"),
          ),
          CSLink(
            title: "Lageplan",
            onPressed: () => launch(
                "https://www.fh-dortmund.de/de/_diverses/anschr/medien/Lageplan_EFS.pdf"),
          ),
          CSLink(
            title: "Zeitplan",
            onPressed: () => launch("https://www.fh-dortmund.de/zeitplan"),
          )
        ],
      ),
    );
  }
}
