import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsManager {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Function(String) onRoute;
  bool _initialized = false;

  PushNotificationsManager();

  void setRouteHandler(Function(String) func) {
    onRoute = func;
  }

  Future<void> init() async {
    if (!_initialized) {
      _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
          alert: true, sound: true, badge: true, provisional: true));

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
}
