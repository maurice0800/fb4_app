import 'package:fb4_app/areas/schedule/models/schedule_settings.dart';
import 'package:fb4_app/areas/schedule/viewmodels/schedule_overview_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
import 'package:json_store/json_store.dart';
import 'package:provider/provider.dart';

class ScheduleSettingsPage extends StatefulWidget {
  final ScheduleSettings settings;
  ScheduleSettingsPage({Key key, this.settings}) : super(key: key);

  @override
  _ScheduleSettingsPageState createState() => _ScheduleSettingsPageState();
}

class _ScheduleSettingsPageState extends State<ScheduleSettingsPage> {
  ScheduleSettings settings = ScheduleSettings();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          heroTag: 'scheduleSettingsPageNavBar',
          transitionBetweenRoutes: false,
          middle: Text("Einstellungen",
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
        ),
        child: CupertinoSettings(items: <Widget>[
          CSButton(CSButtonType.DESTRUCTIVE, "Alle Einträge löschen", () {
            JsonStore().deleteItem("schedule_items");
            Provider.of<ScheduleOverviewViewModel>(context, listen: false)
                .getScheduleListsFromCache();
          })
        ]));
  }
}
