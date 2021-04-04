import 'package:fb4_app/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:screen/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateObserver extends WidgetsBindingObserver {
  final CupertinoTabController controller;
  double _prevBrightness = 0.0;
  int prevIndex = 0;

  AppStateObserver({this.controller}) {
    SharedPreferences.getInstance().then((sharedPrefs) {
      controller.addListener(() async {
        if (controller.index == 3) {
          if ((sharedPrefs.getBool(
                  AppConstants.settingsIncreaseDisplayBrightnessInTicketview) ??
              false)) {
            _prevBrightness = await Screen.brightness;
            Screen.setBrightness(100.0);
          }
        } else if (prevIndex == 3) {
          if ((sharedPrefs.getBool(
                  AppConstants.settingsIncreaseDisplayBrightnessInTicketview) ??
              false)) {
            Screen.setBrightness(_prevBrightness);
          }
        }

        prevIndex = controller.index;
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      var sharedPrefs = await SharedPreferences.getInstance();
      _prevBrightness = await Screen.brightness;

      if ((sharedPrefs.getBool(
              AppConstants.settingsIncreaseDisplayBrightnessInTicketview) ??
          false)) {
        if (controller.index == 3) {
          Screen.setBrightness(100.0);
        }
      }
    } else if (state == AppLifecycleState.inactive) {
      if (prevIndex == 3) {
        Screen.setBrightness(_prevBrightness);
      }
    }
  }
}
