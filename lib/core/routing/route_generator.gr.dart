// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i13;
import 'package:flutter/cupertino.dart' as _i15;
import 'package:flutter/material.dart' as _i14;

import '../../areas/canteen/screens/canteen_overview_page.dart' as _i4;
import '../../areas/more/screens/licenses_page.dart' as _i8;
import '../../areas/more/screens/links_downloads_page.dart' as _i9;
import '../../areas/more/screens/more_list_page.dart' as _i7;
import '../../areas/more/screens/more_page.dart' as _i6;
import '../../areas/more/screens/privacy_page.dart' as _i10;
import '../../areas/more/screens/select_canteens_page.dart' as _i11;
import '../../areas/more/screens/settings_page.dart' as _i12;
import '../../areas/news/screens/news_overview_page.dart' as _i3;
import '../../areas/schedule/screens/schedule_overview_page.dart' as _i2;
import '../../areas/ticket/screens/ticket_viewer_page.dart' as _i5;
import '../../main_page.dart' as _i1;

class AppRouter extends _i13.RootStackRouter {
  AppRouter([_i14.GlobalKey<_i14.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i13.PageFactory> pagesMap = {
    MainRoute.name: (routeData) {
      return _i13.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i1.MainPage());
    },
    ScheduleOverviewRoute.name: (routeData) {
      return _i13.CupertinoPageX<dynamic>(
          routeData: routeData, child: _i2.ScheduleOverviewPage());
    },
    NewsOverviewRoute.name: (routeData) {
      return _i13.CupertinoPageX<dynamic>(
          routeData: routeData, child: _i3.NewsOverviewPage());
    },
    CanteenOverviewRoute.name: (routeData) {
      return _i13.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i4.CanteenOverviewPage());
    },
    TicketViewerRoute.name: (routeData) {
      return _i13.CupertinoPageX<dynamic>(
          routeData: routeData, child: _i5.TicketViewerPage());
    },
    MoreRoute.name: (routeData) {
      return _i13.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i6.MorePage());
    },
    MoreListRoute.name: (routeData) {
      return _i13.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i7.MoreListPage());
    },
    LicensesRoute.name: (routeData) {
      return _i13.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i8.LicensesPage());
    },
    LinksDownloadsRoute.name: (routeData) {
      return _i13.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i9.LinksDownloadsPage());
    },
    PrivacyRoute.name: (routeData) {
      final args = routeData.argsAs<PrivacyRouteArgs>(
          orElse: () => const PrivacyRouteArgs());
      return _i13.CupertinoPageX<dynamic>(
          routeData: routeData,
          child:
              _i10.PrivacyPage(key: args.key, shouldAccept: args.shouldAccept));
    },
    SelectCanteensRoute.name: (routeData) {
      return _i13.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i11.SelectCanteensPage());
    },
    SettingsRoute.name: (routeData) {
      return _i13.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i12.SettingsPage());
    }
  };

  @override
  List<_i13.RouteConfig> get routes => [
        _i13.RouteConfig(MainRoute.name, path: '/', children: [
          _i13.RouteConfig(ScheduleOverviewRoute.name,
              path: 'schedule-overview-page', parent: MainRoute.name),
          _i13.RouteConfig(NewsOverviewRoute.name,
              path: 'news-overview-page', parent: MainRoute.name),
          _i13.RouteConfig(CanteenOverviewRoute.name,
              path: 'canteen-overview-page', parent: MainRoute.name),
          _i13.RouteConfig(TicketViewerRoute.name,
              path: 'ticket-viewer-page', parent: MainRoute.name),
          _i13.RouteConfig(MoreRoute.name,
              path: 'more-page',
              parent: MainRoute.name,
              children: [
                _i13.RouteConfig(MoreListRoute.name,
                    path: '', parent: MoreRoute.name),
                _i13.RouteConfig(LicensesRoute.name,
                    path: 'licenses-page', parent: MoreRoute.name),
                _i13.RouteConfig(LinksDownloadsRoute.name,
                    path: 'links-downloads-page', parent: MoreRoute.name),
                _i13.RouteConfig(PrivacyRoute.name,
                    path: 'privacy-page', parent: MoreRoute.name),
                _i13.RouteConfig(SelectCanteensRoute.name,
                    path: 'select-canteens-page', parent: MoreRoute.name),
                _i13.RouteConfig(SettingsRoute.name,
                    path: 'settings-page', parent: MoreRoute.name)
              ])
        ])
      ];
}

/// generated route for
/// [_i1.MainPage]
class MainRoute extends _i13.PageRouteInfo<void> {
  const MainRoute({List<_i13.PageRouteInfo>? children})
      : super(MainRoute.name, path: '/', initialChildren: children);

  static const String name = 'MainRoute';
}

/// generated route for
/// [_i2.ScheduleOverviewPage]
class ScheduleOverviewRoute extends _i13.PageRouteInfo<void> {
  const ScheduleOverviewRoute()
      : super(ScheduleOverviewRoute.name, path: 'schedule-overview-page');

  static const String name = 'ScheduleOverviewRoute';
}

/// generated route for
/// [_i3.NewsOverviewPage]
class NewsOverviewRoute extends _i13.PageRouteInfo<void> {
  const NewsOverviewRoute()
      : super(NewsOverviewRoute.name, path: 'news-overview-page');

  static const String name = 'NewsOverviewRoute';
}

/// generated route for
/// [_i4.CanteenOverviewPage]
class CanteenOverviewRoute extends _i13.PageRouteInfo<void> {
  const CanteenOverviewRoute()
      : super(CanteenOverviewRoute.name, path: 'canteen-overview-page');

  static const String name = 'CanteenOverviewRoute';
}

/// generated route for
/// [_i5.TicketViewerPage]
class TicketViewerRoute extends _i13.PageRouteInfo<void> {
  const TicketViewerRoute()
      : super(TicketViewerRoute.name, path: 'ticket-viewer-page');

  static const String name = 'TicketViewerRoute';
}

/// generated route for
/// [_i6.MorePage]
class MoreRoute extends _i13.PageRouteInfo<void> {
  const MoreRoute({List<_i13.PageRouteInfo>? children})
      : super(MoreRoute.name, path: 'more-page', initialChildren: children);

  static const String name = 'MoreRoute';
}

/// generated route for
/// [_i7.MoreListPage]
class MoreListRoute extends _i13.PageRouteInfo<void> {
  const MoreListRoute() : super(MoreListRoute.name, path: '');

  static const String name = 'MoreListRoute';
}

/// generated route for
/// [_i8.LicensesPage]
class LicensesRoute extends _i13.PageRouteInfo<void> {
  const LicensesRoute() : super(LicensesRoute.name, path: 'licenses-page');

  static const String name = 'LicensesRoute';
}

/// generated route for
/// [_i9.LinksDownloadsPage]
class LinksDownloadsRoute extends _i13.PageRouteInfo<void> {
  const LinksDownloadsRoute()
      : super(LinksDownloadsRoute.name, path: 'links-downloads-page');

  static const String name = 'LinksDownloadsRoute';
}

/// generated route for
/// [_i10.PrivacyPage]
class PrivacyRoute extends _i13.PageRouteInfo<PrivacyRouteArgs> {
  PrivacyRoute({_i15.Key? key, bool shouldAccept = false})
      : super(PrivacyRoute.name,
            path: 'privacy-page',
            args: PrivacyRouteArgs(key: key, shouldAccept: shouldAccept));

  static const String name = 'PrivacyRoute';
}

class PrivacyRouteArgs {
  const PrivacyRouteArgs({this.key, this.shouldAccept = false});

  final _i15.Key? key;

  final bool shouldAccept;

  @override
  String toString() {
    return 'PrivacyRouteArgs{key: $key, shouldAccept: $shouldAccept}';
  }
}

/// generated route for
/// [_i11.SelectCanteensPage]
class SelectCanteensRoute extends _i13.PageRouteInfo<void> {
  const SelectCanteensRoute()
      : super(SelectCanteensRoute.name, path: 'select-canteens-page');

  static const String name = 'SelectCanteensRoute';
}

/// generated route for
/// [_i12.SettingsPage]
class SettingsRoute extends _i13.PageRouteInfo<void> {
  const SettingsRoute() : super(SettingsRoute.name, path: 'settings-page');

  static const String name = 'SettingsRoute';
}
