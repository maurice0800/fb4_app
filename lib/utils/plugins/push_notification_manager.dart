import 'package:fb4_app/app_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

class PushNotificationsManager {
  Function(String)? onRoute;
  bool _initialized = false;

  PushNotificationsManager();

  void setRouteHandler(Function(String) func) {
    onRoute = func;
  }

  Future<void> init() async {
    await Firebase.initializeApp();
    var prefs = await SharedPreferences.getInstance();

    if (!_initialized) {
      if (prefs.getBool(AppConstants.settingsNotificationOnNews) ?? false) {
        await FirebaseMessaging.instance.requestPermission(
            alert: true, provisional: false, sound: true, badge: true);

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
