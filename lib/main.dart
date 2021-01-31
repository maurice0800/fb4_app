import 'package:fb4_app/areas/more/screens/more_list.dart';
import 'package:fb4_app/areas/news/repositories/news_repository.dart';
import 'package:fb4_app/areas/news/screens/news_overview.dart';
import 'package:fb4_app/areas/schedule/bloc/schedule_item_bloc.dart';
import 'package:fb4_app/areas/schedule/repositories/schedule_repository.dart';
import 'package:fb4_app/areas/schedule/screens/schedule_overview.dart';
import 'package:fb4_app/utils/plugins/push_notification_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'areas/canteen/screens/canteen_overview.dart';
import 'areas/news/bloc/news_item_bloc.dart';

void main() async {
  runApp(FB4App());
  await PushNotificationsManager().init();
}

class FB4App extends StatelessWidget {
  const FB4App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        theme: CupertinoThemeData(
            brightness: Brightness.light,
            primaryColor: CupertinoColors.activeOrange,
            textTheme: CupertinoTextThemeData(
                textStyle: TextStyle(color: CupertinoColors.white),
                primaryColor: CupertinoColors.black,
                navTitleTextStyle: TextStyle(
                    color: CupertinoColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    background: null,
                    backgroundColor: null,
                    debugLabel: "navTitleTextStyle",
                    decoration: null,
                    decorationColor: null,
                    decorationStyle: null,
                    decorationThickness: null,
                    fontFamily: null,
                    fontFamilyFallback: null,
                    fontFeatures: null,
                    fontStyle: null,
                    foreground: null,
                    height: null,
                    inherit: false,
                    letterSpacing: null,
                    locale: null,
                    package: null,
                    shadows: null,
                    textBaseline: null,
                    wordSpacing: null))),
        home: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(currentIndex: 2, items: [
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
              case 4:
                return MoreList();
            }
          },
        ));
  }
}
