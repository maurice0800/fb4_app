import 'package:fb4_app/areas/more/screens/more_list.dart';
import 'package:fb4_app/areas/news/repositories/news_repository.dart';
import 'package:fb4_app/areas/news/screens/news_overview.dart';
import 'package:fb4_app/areas/schedule/bloc/schedule_item_bloc.dart';
import 'package:fb4_app/areas/schedule/repositories/schedule_repository.dart';
import 'package:fb4_app/areas/schedule/screens/schedule_overview.dart';
import 'package:fb4_app/areas/ticket/screens/ticket_viewer_page.dart';
import 'package:fb4_app/config/themes/dark_theme.dart';
import 'package:fb4_app/utils/plugins/push_notification_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'areas/canteen/screens/canteen_overview.dart';
import 'areas/news/bloc/news_item_bloc.dart';
import 'package:fb4_app/areas/ticket/bloc/ticket_bloc.dart';

import 'config/themes/light_theme.dart';

void main() async {
  runApp(FB4App());
  await PushNotificationsManager().init();
}

class FB4App extends StatelessWidget {
  const FB4App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool darkMode =
        SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return CupertinoApp(
        theme: darkMode ? DarkTheme.themeData : LightTheme.themeData,
        home: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
              backgroundColor:
                  CupertinoTheme.of(context).scaffoldBackgroundColor,
              currentIndex: 2,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.calendar), label: 'Stundenplan'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.news), label: 'News'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.bitcoin_circle), label: 'Mensa'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.ticket), label: 'Semesterticket'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.ellipsis), label: 'Mehr'),
              ]),
          tabBuilder: (context, index) {
            switch (index) {
              case 0:
                return BlocProvider(
                    create: (BuildContext context) =>
                        ScheduleItemBloc(repository: ScheduleRepository()),
                    child: ScheduleOverview());
              case 1:
                return BlocProvider(
                  create: (context) =>
                      NewsItemBloc(newsRepository: NewsRepository()),
                  child: NewsOverview(),
                );
              case 2:
                return CanteenOverview();
              case 3:
                return BlocProvider(
                    create: (context) => TicketBloc(),
                    child: TicketViewerPage());
              case 4:
                return MoreList();
              default:
                throw Exception("User tried to open an invalid page.");
            }
          },
        ));
  }
}
