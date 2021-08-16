import 'package:fb4_app/app_constants.dart';
import 'package:fb4_app/areas/ods/repositories/ods_repository.dart';
import 'package:fb4_app/areas/ods/viewmodels/grades_overview_page_viewmodel.dart';
import 'package:fb4_app/areas/schedule/viewmodels/schedule_overview_viewmodel.dart';
import 'package:fb4_app/areas/ticket/viewmodels/ticket_overview_viewmodel.dart';
import 'package:fb4_app/utils/plugins/push_notification_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:json_store/json_store.dart';
import 'package:kiwi/kiwi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPageViewModel extends ChangeNotifier {
  bool _increaseDisplayBrightnessInTicketview = false;
  bool _notificaitonOnNews = false;
  bool _goToCurrentWeekInSchedule = false;

  void init() {
    SharedPreferences.getInstance().then((s) {
      _increaseDisplayBrightnessInTicketview = s.getBool(
              AppConstants.settingsIncreaseDisplayBrightnessInTicketview) ??
          false;

      _notificaitonOnNews =
          s.getBool(AppConstants.settingsNotificationOnNews) ?? false;

      _goToCurrentWeekInSchedule =
          s.getBool(AppConstants.settingsGoToCurrentDayInSchedule) ?? false;

      notifyListeners();
    });
  }

  bool get increaseDisplayBrightnessInTicketview =>
      _increaseDisplayBrightnessInTicketview;

  set increaseDisplayBrightnessInTicketview(bool val) {
    _increaseDisplayBrightnessInTicketview = val;
    SharedPreferences.getInstance().then((s) => s.setBool(
        AppConstants.settingsIncreaseDisplayBrightnessInTicketview, val));
    notifyListeners();
  }

  bool get notificationOnNews => _notificaitonOnNews;

  set notificationOnNews(bool val) {
    _notificaitonOnNews = val;
    SharedPreferences.getInstance().then((s) {
      s.setBool(AppConstants.settingsNotificationOnNews, val);

      if (val) {
        PushNotificationsManager().init();
      } else {
        PushNotificationsManager().unsubscribe();
      }
    });
    notifyListeners();
  }

  bool get goToCurrentDayInSchedule => _goToCurrentWeekInSchedule;

  set goToCurrentDayInSchedule(bool val) {
    _goToCurrentWeekInSchedule = val;
    SharedPreferences.getInstance().then((s) {
      s.setBool(AppConstants.settingsGoToCurrentDayInSchedule, val);
      notifyListeners();
    });
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
