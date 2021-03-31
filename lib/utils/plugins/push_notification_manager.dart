import 'package:fb4_app/app_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationsManager {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Function(String) onRoute;
  bool _initialized = false;

  PushNotificationsManager();

  void setRouteHandler(Function(String) func) {
    onRoute = func;
  }

  Future<void> init() async {
    var prefs = await SharedPreferences.getInstance();

    if (!_initialized) {
      if (prefs.getBool(AppConstants.settingsNotificationOnNews) ?? false) {
        await _firebaseMessaging.requestNotificationPermissions(
            IosNotificationSettings(
                alert: true, provisional: false, sound: true, badge: true));

        _firebaseMessaging.subscribeToTopic("Aktuelles");
      } else {
        return;
      }

      _firebaseMessaging.configure(
        onResume: (Map<String, dynamic> message) async {
          if (onRoute != null) {
            onRoute(message['route']);
          }
        },
        onLaunch: (Map<String, dynamic> message) async {
          if (onRoute != null) {
            onRoute(message['route']);
          }
        },
      );

      _initialized = true;
    }
  }

  void unsubscribe() {
    _firebaseMessaging.unsubscribeFromTopic("Aktuelles");
  }
}
