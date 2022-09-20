import 'package:brightness_volume/brightness_volume.dart';
import 'package:fb4_app/app_constants.dart';
import 'package:fb4_app/core/settings/settings_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:kiwi/kiwi.dart';

class AppStateObserver extends WidgetsBindingObserver {
  final CupertinoTabController controller;
  final SettingsService _settingsService =
      KiwiContainer().resolve<SettingsService>();
  double _prevBrightness = 0.0;
  int prevIndex = 0;

  AppStateObserver({required this.controller}) {
    controller.addListener(() async {
      if (controller.index == 3) {
        if (_settingsService.getBool(
              AppConstants.settingsIncreaseDisplayBrightnessInTicketview,
            ) ??
            false) {
          _prevBrightness = await BVUtils.brightness;
          BVUtils.setBrightness(100.0);
        }
      } else if (prevIndex == 3) {
        if (_settingsService.getBool(
              AppConstants.settingsIncreaseDisplayBrightnessInTicketview,
            ) ??
            false) {
          BVUtils.setBrightness(_prevBrightness);
        }
      }

      prevIndex = controller.index;
    });
  }

  @override
  Future didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      _prevBrightness = await BVUtils.brightness;

      if (_settingsService.getBool(
            AppConstants.settingsIncreaseDisplayBrightnessInTicketview,
          ) ??
          false) {
        if (controller.index == 3) {
          BVUtils.setBrightness(100.0);
        }
      }
    } else if (state == AppLifecycleState.inactive) {
      if (prevIndex == 3) {
        BVUtils.setBrightness(_prevBrightness);
      }
    }
  }
}
