import 'package:fb4_app/areas/canteen/repositories/canteens_repository.dart';
import 'package:fb4_app/areas/canteen/repositories/meals_repository.dart';
import 'package:fb4_app/areas/canteen/viewmodels/canteen_overview_viewmodel.dart';
import 'package:fb4_app/areas/more/viewmodels/licenses_page_viewmodel.dart';
import 'package:fb4_app/areas/more/viewmodels/privacy_page_viewmodel.dart';
import 'package:fb4_app/areas/more/viewmodels/select_canteens_page_viewmodel.dart';
import 'package:fb4_app/areas/more/viewmodels/settings_page_view_model.dart';
import 'package:fb4_app/areas/news/viewmodels/news_overview_viewmodel.dart';
import 'package:fb4_app/areas/ods/viewmodels/grades_overview_page_viewmodel.dart';
import 'package:fb4_app/areas/ods/viewmodels/login_page_viewmodel.dart';
import 'package:fb4_app/areas/schedule/viewmodels/add_custom_schedule_item_page_viewmodel.dart';
import 'package:fb4_app/areas/schedule/viewmodels/add_official_schedule_page_viewmodel.dart';
import 'package:fb4_app/areas/schedule/viewmodels/schedule_overview_viewmodel.dart';
import 'package:fb4_app/areas/ticket/viewmodels/ticket_overview_viewmodel.dart';
import 'package:fb4_app/config/themes/dark_theme.dart';
import 'package:fb4_app/config/themes/light_theme.dart';
import 'package:fb4_app/core/routing/route_generator.gr.dart';
import 'package:fb4_app/core/settings/settings_service.dart';
import 'package:fb4_app/main_view_model.dart';
import 'package:fb4_app/utils/helpers/app_state_oberserver.dart';
import 'package:fb4_app/utils/plugins/push_notification_manager.dart';
import 'package:fb4_app/utils/plugins/quick_actions_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kiwi/kiwi.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  await registerDependencies();

  final notificationManager = PushNotificationsManager();
  final appTabController = CupertinoTabController();
  final quickActionsManager = QuickActionsManager(appTabController);

  await initializeDateFormatting("de_DE");

  runApp(FB4App(controller: appTabController));
  quickActionsManager.init();

  WidgetsBinding.instance
      .addObserver(AppStateObserver(controller: appTabController));

  await notificationManager.init();
  notificationManager.onRoute = (route) {
    appTabController.index = 1;
  };
}

Future registerDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settings = await SharedPreferences.getInstance();
  KiwiContainer().registerInstance<SharedPreferences>(settings);
  KiwiContainer()
      .registerSingleton<SettingsService>((container) => SettingsService());

  KiwiContainer().registerSingleton<ScheduleOverviewViewModel>(
    (container) => ScheduleOverviewViewModel(),
  );
  KiwiContainer()
      .registerSingleton<MainViewModel>((container) => MainViewModel());
  KiwiContainer().registerSingleton<AddOfficialSchedulePageViewModel>(
    (container) => AddOfficialSchedulePageViewModel(),
  );
  KiwiContainer().registerSingleton<NewsOverviewViewModel>(
    (container) => NewsOverviewViewModel(),
  );
  KiwiContainer().registerSingleton<TicketOverviewViewModel>(
    (container) => TicketOverviewViewModel(),
  );
  KiwiContainer().registerSingleton<LicensesPageViewModel>(
    (container) => LicensesPageViewModel(),
  );
  KiwiContainer().registerSingleton<PrivacyPageViewModel>(
    (container) => PrivacyPageViewModel(),
  );
  KiwiContainer().registerFactory<AddCustomScheduleItemPageViewModel>(
    (container) => AddCustomScheduleItemPageViewModel(),
  );
  KiwiContainer().registerSingleton<SettingsPageViewModel>(
    (container) => SettingsPageViewModel(),
  );
  KiwiContainer().registerSingleton<LoginPageViewModel>(
    (container) => LoginPageViewModel(),
  );
  KiwiContainer().registerSingleton<GradeOverviewPageViewModel>(
    (container) => GradeOverviewPageViewModel(),
  );
  KiwiContainer().registerSingleton<SelectCanteensPageViewModel>(
    (container) => SelectCanteensPageViewModel(),
  );
  KiwiContainer().registerSingleton<CanteensRepository>(
    (container) => CanteensRepository(),
  );
  KiwiContainer().registerSingleton<CanteenOverviewViewModel>((container) {
    return CanteenOverviewViewModel()..loadEnabledCanteensFromSettings();
  });
  KiwiContainer()
      .registerSingleton<MealsRepository>((container) => MealsRepository());
}

class FB4App extends StatelessWidget {
  final CupertinoTabController controller;

  const FB4App({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool darkMode =
        SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    final router = AppRouter();

    return CupertinoApp.router(
      routerDelegate: router.delegate(),
      routeInformationParser: router.defaultRouteParser(),
      debugShowCheckedModeBanner: false,
      theme: darkMode ? darkThemeData : lightThemeData,
    );
  }
}
