import 'package:fb4_app/app_constants.dart';
import 'package:fb4_app/areas/schedule/viewmodels/schedule_overview_viewmodel.dart';
import 'package:fb4_app/areas/ticket/viewmodels/ticket_overview_viewmodel.dart';
import 'package:fb4_app/utils/plugins/push_notification_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_store/json_store.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPageViewModel extends ChangeNotifier {
  bool _increaseDisplayBrightnessInTicketview = false;
  bool _notificaitonOnNews = false;

  init() {
    SharedPreferences.getInstance().then((s) {
      _increaseDisplayBrightnessInTicketview = s.getBool(
              AppConstants.settingsIncreaseDisplayBrightnessInTicketview) ??
          false;

      _notificaitonOnNews =
          s.get(AppConstants.settingsNotificationOnNews) ?? false;

      notifyListeners();
    });
  }

  get increaseDisplayBrightnessInTicketview =>
      _increaseDisplayBrightnessInTicketview;

  set increaseDisplayBrightnessInTicketview(bool val) {
    _increaseDisplayBrightnessInTicketview = val;
    SharedPreferences.getInstance().then((s) => s.setBool(
        AppConstants.settingsIncreaseDisplayBrightnessInTicketview, val));
    notifyListeners();
  }

  get notificationOnNews => _notificaitonOnNews;

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

  void deleteTicket(BuildContext context) {
    try {
      Provider.of<TicketOverviewViewModel>(context, listen: false)
          .deleteTicket();
    } on ArgumentError {}
  }

  void deleteSchedule(BuildContext context) {
    JsonStore().deleteItem("schedule_items");
    Provider.of<ScheduleOverviewViewModel>(context, listen: false)
        .getScheduleListsFromCache();
  }
}
