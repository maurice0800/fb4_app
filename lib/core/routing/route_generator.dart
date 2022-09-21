import 'package:auto_route/auto_route.dart';
import 'package:fb4_app/areas/canteen/screens/canteen_overview_page.dart';
import 'package:fb4_app/areas/more/screens/licenses_page.dart';
import 'package:fb4_app/areas/more/screens/links_downloads_page.dart';
import 'package:fb4_app/areas/more/screens/more_list_page.dart';
import 'package:fb4_app/areas/more/screens/more_page.dart';
import 'package:fb4_app/areas/more/screens/privacy_page.dart';
import 'package:fb4_app/areas/more/screens/select_canteens_page.dart';
import 'package:fb4_app/areas/more/screens/settings_page.dart';
import 'package:fb4_app/areas/news/screens/news_overview_page.dart';
import 'package:fb4_app/areas/schedule/screens/schedule_overview_page.dart';
import 'package:fb4_app/areas/ticket/screens/ticket_viewer_page.dart';
import 'package:fb4_app/main_page.dart';

@CupertinoAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: MainPage,
      initial: true,
      children: <AutoRoute>[
        AutoRoute(page: ScheduleOverviewPage),
        AutoRoute(page: NewsOverviewPage),
        AutoRoute(page: CanteenOverviewPage),
        AutoRoute(page: TicketViewerPage),
        AutoRoute(
          page: MorePage,
          children: <AutoRoute>[
            AutoRoute(page: MoreListPage, initial: true),
            AutoRoute(page: LicensesPage),
            AutoRoute(page: LinksDownloadsPage),
            AutoRoute(page: PrivacyPage),
            AutoRoute(page: SelectCanteensPage),
            AutoRoute(page: SettingsPage),
          ],
        ),
      ],
    ),
  ],
)
class $AppRouter {}
