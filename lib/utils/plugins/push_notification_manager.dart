import 'package:fb4_app/app_constants.dart';
import 'package:fb4_app/core/settings/settings_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kiwi/kiwi.dart';

class PushNotificationsManager {
  late final SettingsService _settingsService;
  Function(String)? onRoute;
  bool _initialized = false;

  PushNotificationsManager() {
    _settingsService = KiwiContainer().resolve<SettingsService>();

    _settingsService.settingsChangedEvent.listen((e) {
      if (e.settingName == AppConstants.settingsNotificationOnNews) {
        if (e.newValue == true) {
          init();
        } else {
          unsubscribe();
        }
      }
    });
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    if (!_initialized) {
      if (_settingsService.getBool(AppConstants.settingsNotificationOnNews) ??
          false) {
        await FirebaseMessaging.instance.requestPermission();

        FirebaseMessaging.instance.subscribeToTopic("Aktuelles");
      } else {
        return;
      }

      // FirebaseMessaging.onMessage(
      //   onResume: (Map<String, dynamic> message) async {
      //     if (onRoute != null) {
      //       onRoute(message['route'].toString());
      //     }
      //   },
      //   onLaunch: (Map<String, dynamic> message) async {
      //     if (onRoute != null) {
      //       onRoute(message['route'].toString());
      //     }
      //   },
      // );

      _initialized = true;
    }
  }

  void unsubscribe() {
    FirebaseMessaging.instance.unsubscribeFromTopic("Aktuelles");
  }
}
