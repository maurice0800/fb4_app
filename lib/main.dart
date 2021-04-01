import 'package:fb4_app/app_constants.dart';
import 'package:fb4_app/areas/more/screens/more_list.dart';
import 'package:fb4_app/areas/news/screens/news_overview.dart';
import 'package:fb4_app/areas/schedule/screens/schedule_overview.dart';
import 'package:fb4_app/areas/schedule/viewmodels/schedule_overview_viewmodel.dart';
import 'package:fb4_app/areas/ticket/screens/ticket_viewer_page.dart';
import 'package:fb4_app/areas/ticket/viewmodels/ticket_overview_viewmodel.dart';
import 'package:fb4_app/config/themes/dark_theme.dart';
import 'package:fb4_app/utils/plugins/push_notification_manager.dart';
import 'package:fb4_app/utils/ui/icons/fb4app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'areas/canteen/screens/canteen_overview.dart';

import 'config/themes/light_theme.dart';

void main() async {
  int prevIndex = 0;
  double prevBrightness = 0;
  var appTabController = CupertinoTabController();
  var notificationManager = PushNotificationsManager();

  runApp(FB4App(
    controller: appTabController,
  ));

  var sharedPrefs = await SharedPreferences.getInstance();
  appTabController.addListener(() async {
    if (appTabController.index == 3) {
      if (sharedPrefs.getBool(
          AppConstants.settingsIncreaseDisplayBrightnessInTicketview)) {
        prevBrightness = await Screen.brightness;
        Screen.setBrightness(100.0);
      }
    } else if (prevIndex == 3) {
      if (sharedPrefs.getBool(
          AppConstants.settingsIncreaseDisplayBrightnessInTicketview)) {
        Screen.setBrightness(prevBrightness);
      }
    }

    prevIndex = appTabController.index;
  });

  await notificationManager.init();
  notificationManager.setRouteHandler((route) {
    appTabController.index = 1;
  });
}

class FB4App extends StatelessWidget {
  final CupertinoTabController controller;

  const FB4App({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool darkMode =
        SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ChangeNotifierProvider<ScheduleOverviewViewModel>(
        create: (context) => ScheduleOverviewViewModel(),
        child: CupertinoApp(
            theme: darkMode ? DarkTheme.themeData : LightTheme.themeData,
            home: CupertinoTabScaffold(
              controller: controller,
              tabBar: CupertinoTabBar(currentIndex: 0, items: [
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.calendar), label: 'Stundenplan'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.news), label: 'News'),
                BottomNavigationBarItem(
                    icon: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Icon(FB4Icons.food, size: 25)),
                    label: 'Mensa'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.ticket), label: 'Semesterticket'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.ellipsis), label: 'Mehr'),
              ]),
              tabBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return ScheduleOverview();
                  case 1:
                    return NewsOverview();
                  case 2:
                    return CanteenOverview();
                  case 3:
                    return ChangeNotifierProvider(
                      create: (context) => TicketOverviewViewModel()..init(),
                      child: TicketViewerPage(),
                    );
                  case 4:
                    return MoreList();
                  default:
                    throw Exception("User tried to open an invalid page.");
                }
              },
            )));
  }
}
