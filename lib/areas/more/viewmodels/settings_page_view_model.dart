import 'package:fb4_app/app_constants.dart';
import 'package:fb4_app/areas/ods/repositories/ods_repository.dart';
import 'package:fb4_app/areas/ods/viewmodels/grades_overview_page_viewmodel.dart';
import 'package:fb4_app/areas/schedule/viewmodels/schedule_overview_viewmodel.dart';
import 'package:fb4_app/areas/ticket/viewmodels/ticket_overview_viewmodel.dart';
import 'package:fb4_app/core/settings/settings_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:json_store/json_store.dart';
import 'package:kiwi/kiwi.dart';

class SettingsPageViewModel extends ChangeNotifier {
  late final SettingsService _settingsService;

  SettingsPageViewModel() {
    _settingsService = KiwiContainer().resolve<SettingsService>();
  }

  bool get increaseDisplayBrightnessInTicketview =>
      _settingsService.getBool(
        AppConstants.settingsIncreaseDisplayBrightnessInTicketview,
      ) ??
      false;

  set increaseDisplayBrightnessInTicketview(bool val) {
    _settingsService.saveBool(
      AppConstants.settingsIncreaseDisplayBrightnessInTicketview,
      val,
    );
    notifyListeners();
  }

  bool get notificationOnNews =>
      _settingsService.getBool(AppConstants.settingsNotificationOnNews) ??
      false;

  set notificationOnNews(bool val) {
    _settingsService.saveBool(AppConstants.settingsNotificationOnNews, val);
    notifyListeners();
  }

  bool get goToCurrentDayInSchedule =>
      _settingsService.getBool(AppConstants.settingsGoToCurrentDayInSchedule) ??
      false;

  set goToCurrentDayInSchedule(bool val) {
    _settingsService.saveBool(
      AppConstants.settingsGoToCurrentDayInSchedule,
      val,
    );
    notifyListeners();
  }

  void deleteTicket(BuildContext context) {
    KiwiContainer().resolve<TicketOverviewViewModel>().deleteTicket();
  }

  void deleteSchedule(BuildContext context) {
    JsonStore().deleteLike("schedule%");
    KiwiContainer()
        .resolve<ScheduleOverviewViewModel>()
        .getScheduleListsFromDatabase();
  }

  Future<void> logoutOds() async {
    await const FlutterSecureStorage().delete(key: "odsUsername");
    await const FlutterSecureStorage().delete(key: "odsPassword");
    OdsRepository.cachedToken = "";
    KiwiContainer().resolve<GradeOverviewPageViewModel>().exams.clear();
  }
}
