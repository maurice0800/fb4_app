// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as i7;
import 'package:fb4_app/areas/canteen/screens/canteen_overview_page.dart' as i4;
import 'package:fb4_app/areas/more/screens/more_list_page.dart' as i6;
import 'package:fb4_app/areas/news/screens/news_overview_page.dart' as i3;
import 'package:fb4_app/areas/schedule/screens/schedule_overview_page.dart'
    as i2;
import 'package:fb4_app/areas/ticket/screens/ticket_viewer_page.dart' as i5;
import 'package:fb4_app/main_page.dart' as i1;
import 'package:flutter/material.dart' as i8;

class AppRouter extends i7.RootStackRouter {
  AppRouter([i8.GlobalKey<i8.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, i7.PageFactory> pagesMap = {
    MainRoute.name: (routeData) {
      return i7.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const i1.MainPage(),
      );
    },
    ScheduleOverviewRoute.name: (routeData) {
      return i7.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: i2.ScheduleOverviewPage(),
      );
    },
    NewsOverviewRoute.name: (routeData) {
      return i7.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: i3.NewsOverviewPage(),
      );
    },
    CanteenOverviewRoute.name: (routeData) {
      return i7.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const i4.CanteenOverviewPage(),
      );
    },
    TicketViewerRoute.name: (routeData) {
      return i7.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: i5.TicketViewerPage(),
      );
    },
    MoreListRoute.name: (routeData) {
      return i7.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const i6.MoreListPage(),
      );
    }
  };

  @override
  List<i7.RouteConfig> get routes => [
        i7.RouteConfig(
          MainRoute.name,
          path: '/',
          children: [
            i7.RouteConfig(
              ScheduleOverviewRoute.name,
              path: 'schedule-overview-page',
              parent: MainRoute.name,
            ),
            i7.RouteConfig(
              NewsOverviewRoute.name,
              path: 'news-overview-page',
              parent: MainRoute.name,
            ),
            i7.RouteConfig(
              CanteenOverviewRoute.name,
              path: 'canteen-overview-page',
              parent: MainRoute.name,
            ),
            i7.RouteConfig(
              TicketViewerRoute.name,
              path: 'ticket-viewer-page',
              parent: MainRoute.name,
            ),
            i7.RouteConfig(
              MoreListRoute.name,
              path: 'more-list-page',
              parent: MainRoute.name,
            )
          ],
        )
      ];
}

/// generated route for [i1.MainPage]
class MainRoute extends i7.PageRouteInfo<void> {
  const MainRoute({List<i7.PageRouteInfo>? children})
      : super(name, path: '/', initialChildren: children);

  static const String name = 'MainRoute';
}

/// generated route for [i2.ScheduleOverviewPage]
class ScheduleOverviewRoute extends i7.PageRouteInfo<void> {
  const ScheduleOverviewRoute() : super(name, path: 'schedule-overview-page');

  static const String name = 'ScheduleOverviewRoute';
}

/// generated route for [i3.NewsOverviewPage]
class NewsOverviewRoute extends i7.PageRouteInfo<void> {
  const NewsOverviewRoute() : super(name, path: 'news-overview-page');

  static const String name = 'NewsOverviewRoute';
}

/// generated route for [i4.CanteenOverviewPage]
class CanteenOverviewRoute extends i7.PageRouteInfo<void> {
  const CanteenOverviewRoute() : super(name, path: 'canteen-overview-page');

  static const String name = 'CanteenOverviewRoute';
}

/// generated route for [i5.TicketViewerPage]
class TicketViewerRoute extends i7.PageRouteInfo<void> {
  const TicketViewerRoute() : super(name, path: 'ticket-viewer-page');

  static const String name = 'TicketViewerRoute';
}

/// generated route for [i6.MoreListPage]
class MoreListRoute extends i7.PageRouteInfo<void> {
  const MoreListRoute() : super(name, path: 'more-list-page');

  static const String name = 'MoreListRoute';
}
