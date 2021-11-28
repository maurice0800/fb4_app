import 'package:fb4_app/areas/canteen/repositories/canteens_repository.dart';
import 'package:fb4_app/areas/more/screens/more_list.dart';
import 'package:fb4_app/areas/more/screens/privacy_page.dart';
import 'package:fb4_app/areas/more/viewmodels/licenses_page_viewmodel.dart';
import 'package:fb4_app/areas/more/viewmodels/privacy_page_viewmodel.dart';
import 'package:fb4_app/areas/more/viewmodels/settings_page_view_model.dart';
import 'package:fb4_app/areas/news/screens/news_overview.dart';
import 'package:fb4_app/areas/news/viewmodels/news_overview_viewmodel.dart';
import 'package:fb4_app/areas/ods/viewmodels/grades_overview_page_viewmodel.dart';
import 'package:fb4_app/areas/ods/viewmodels/login_page_viewmodel.dart';
import 'package:fb4_app/areas/schedule/screens/schedule_overview.dart';
import 'package:fb4_app/areas/schedule/viewmodels/add_custom_schedule_item_page_viewmodel.dart';
import 'package:fb4_app/areas/schedule/viewmodels/add_official_schedule_page_viewmodel.dart';
import 'package:fb4_app/areas/schedule/viewmodels/schedule_overview_viewmodel.dart';
import 'package:fb4_app/areas/ticket/screens/ticket_viewer_page.dart';
import 'package:fb4_app/areas/ticket/viewmodels/ticket_overview_viewmodel.dart';
import 'package:fb4_app/config/themes/dark_theme.dart';
import 'package:fb4_app/core/settings/settings_service.dart';
import 'package:fb4_app/main_view_model.dart';
import 'package:fb4_app/utils/helpers/app_state_oberserver.dart';
import 'package:fb4_app/utils/plugins/push_notification_manager.dart';
import 'package:fb4_app/utils/plugins/quick_actions_manager.dart';
import 'package:fb4_app/utils/ui/icons/fb4app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kiwi/kiwi.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'areas/canteen/repositories/meals_repository.dart';
import 'areas/canteen/screens/canteen_overview.dart';

import 'areas/canteen/viewmodels/canteen_overview_viewmodel.dart';
import 'areas/more/viewmodels/select_canteens_page_viewmodel.dart';
import 'config/themes/light_theme.dart';

void main() async {
  final appTabController = CupertinoTabController();
  final notificationManager = PushNotificationsManager();
  final quickActionsManager = QuickActionsManager(appTabController);

  registerDependencies();
  await initializeDateFormatting("de_DE");

  runApp(FB4App(controller: appTabController));
  quickActionsManager.init();

  WidgetsBinding.instance!
      .addObserver(AppStateObserver(controller: appTabController));

  await notificationManager.init();
  notificationManager.setRouteHandler((route) {
    appTabController.index = 1;
  });
}

void registerDependencies() async {
  Future registerDependencies() async {
    WidgetsFlutterBinding.ensureInitialized();

    final settings = await SharedPreferences.getInstance();
    KiwiContainer().registerInstance<SharedPreferences>(settings);

    KiwiContainer()
        .registerSingleton<SettingsService>((container) => SettingsService());
    KiwiContainer().registerSingleton<ScheduleOverviewViewModel>(
        (container) => ScheduleOverviewViewModel());
    KiwiContainer().registerSingleton<AddOfficialSchedulePageViewModel>(
        (container) => AddOfficialSchedulePageViewModel());
    KiwiContainer().registerSingleton<NewsOverviewViewModel>(
        (container) => NewsOverviewViewModel());
    KiwiContainer().registerSingleton<TicketOverviewViewModel>(
        (container) => TicketOverviewViewModel());
    KiwiContainer().registerSingleton<LicensesPageViewModel>(
        (container) => LicensesPageViewModel());
    KiwiContainer().registerSingleton<PrivacyPageViewModel>(
        (container) => PrivacyPageViewModel());
    KiwiContainer().registerFactory<AddCustomScheduleItemPageViewModel>(
        (container) => AddCustomScheduleItemPageViewModel());
    KiwiContainer().registerSingleton<SettingsPageViewModel>(
        (container) => SettingsPageViewModel());
    KiwiContainer().registerSingleton<LoginPageViewModel>(
        (container) => LoginPageViewModel());
    KiwiContainer().registerSingleton<GradeOverviewPageViewModel>(
        (container) => GradeOverviewPageViewModel());
    KiwiContainer().registerSingleton<SelectCanteensPageViewModel>(
        (container) => SelectCanteensPageViewModel());
    KiwiContainer().registerSingleton<CanteensRepository>(
        (container) => CanteensRepository());
    KiwiContainer().registerSingleton<CanteenOverviewViewModel>((container) {
      return CanteenOverviewViewModel()..loadEnabledCanteensFromSettings();
    });
    KiwiContainer()
        .registerSingleton<MealsRepository>((container) => MealsRepository());
  }
}

class FB4App extends StatelessWidget {
  final CupertinoTabController controller;

  const FB4App({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool darkMode =
        SchedulerBinding.instance!.window.platformBrightness == Brightness.dark;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MainViewModel()..init()),
        ],
        child: Consumer<MainViewModel>(
          builder: (context, viewModel, child) => CupertinoApp(
            debugShowCheckedModeBanner: false,
            theme: darkMode ? DarkTheme.themeData : LightTheme.themeData,
            home: viewModel.isInitialized
                ? (viewModel.shouldShowPrivacyPolicy
                    ? ChangeNotifierProvider(
                        create: (context) => PrivacyPageViewModel()..load(),
                        child: PrivacyPage(
                          shouldAccept: true,
                        ),
                      )
                    : CupertinoTabScaffold(
                        controller: controller,
                        tabBar: CupertinoTabBar(currentIndex: 0, items: [
                          BottomNavigationBarItem(
                              icon: Icon(CupertinoIcons.calendar),
                              label: 'Stundenplan'),
                          BottomNavigationBarItem(
                              icon: Icon(CupertinoIcons.news), label: 'News'),
                          BottomNavigationBarItem(
                              icon: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Icon(FB4Icons.food, size: 25)),
                              label: 'Mensa'),
                          BottomNavigationBarItem(
                              icon: Icon(CupertinoIcons.ticket),
                              label: 'Semesterticket'),
                          BottomNavigationBarItem(
                              icon: Icon(CupertinoIcons.ellipsis),
                              label: 'Mehr'),
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
                              return TicketViewerPage();
                            case 4:
                              return MoreList();
                            default:
                              throw Exception(
                                  "User tried to open an invalid page.");
                          }
                        },
                      ))
                : CupertinoPageScaffold(
                    child: SafeArea(
                    child: Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  )),
          ),
        ));
  }
}
