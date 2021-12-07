// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;

import '../../areas/canteen/screens/canteen_overview_page.dart' as _i4;
import '../../areas/more/screens/more_list_page.dart' as _i6;
import '../../areas/news/screens/news_overview_page.dart' as _i3;
import '../../areas/schedule/screens/schedule_overview_page.dart' as _i2;
import '../../areas/ticket/screens/ticket_viewer_page.dart' as _i5;
import '../../main_page.dart' as _i1;

class AppRouter extends _i7.RootStackRouter {
  AppRouter([_i8.GlobalKey<_i8.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    MainRoute.name: (routeData) {
      return _i7.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i1.MainPage());
    },
    ScheduleOverviewRoute.name: (routeData) {
      return _i7.CupertinoPageX<dynamic>(
          routeData: routeData, child: _i2.ScheduleOverviewPage());
    },
    NewsOverviewRoute.name: (routeData) {
      return _i7.CupertinoPageX<dynamic>(
          routeData: routeData, child: _i3.NewsOverviewPage());
    },
    CanteenOverviewRoute.name: (routeData) {
      return _i7.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i4.CanteenOverviewPage());
    },
    TicketViewerRoute.name: (routeData) {
      return _i7.CupertinoPageX<dynamic>(
          routeData: routeData, child: _i5.TicketViewerPage());
    },
    MoreListRoute.name: (routeData) {
      return _i7.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i6.MoreListPage());
    }
  };

  @override
  List<_i7.RouteConfig> get routes => [
        _i7.RouteConfig(MainRoute.name, path: '/', children: [
          _i7.RouteConfig(ScheduleOverviewRoute.name,
              path: 'schedule-overview-page', parent: MainRoute.name),
          _i7.RouteConfig(NewsOverviewRoute.name,
              path: 'news-overview-page', parent: MainRoute.name),
          _i7.RouteConfig(CanteenOverviewRoute.name,
              path: 'canteen-overview-page', parent: MainRoute.name),
          _i7.RouteConfig(TicketViewerRoute.name,
              path: 'ticket-viewer-page', parent: MainRoute.name),
          _i7.RouteConfig(MoreListRoute.name,
              path: 'more-list-page', parent: MainRoute.name)
        ])
      ];
}

/// generated route for [_i1.MainPage]
class MainRoute extends _i7.PageRouteInfo<void> {
  const MainRoute({List<_i7.PageRouteInfo>? children})
      : super(name, path: '/', initialChildren: children);

  static const String name = 'MainRoute';
}

/// generated route for [_i2.ScheduleOverviewPage]
class ScheduleOverviewRoute extends _i7.PageRouteInfo<void> {
  const ScheduleOverviewRoute() : super(name, path: 'schedule-overview-page');

  static const String name = 'ScheduleOverviewRoute';
}

/// generated route for [_i3.NewsOverviewPage]
class NewsOverviewRoute extends _i7.PageRouteInfo<void> {
  const NewsOverviewRoute() : super(name, path: 'news-overview-page');

  static const String name = 'NewsOverviewRoute';
}

/// generated route for [_i4.CanteenOverviewPage]
class CanteenOverviewRoute extends _i7.PageRouteInfo<void> {
  const CanteenOverviewRoute() : super(name, path: 'canteen-overview-page');

  static const String name = 'CanteenOverviewRoute';
}

/// generated route for [_i5.TicketViewerPage]
class TicketViewerRoute extends _i7.PageRouteInfo<void> {
  const TicketViewerRoute() : super(name, path: 'ticket-viewer-page');

  static const String name = 'TicketViewerRoute';
}

/// generated route for [_i6.MoreListPage]
class MoreListRoute extends _i7.PageRouteInfo<void> {
  const MoreListRoute() : super(name, path: 'more-list-page');

  static const String name = 'MoreListRoute';
}
