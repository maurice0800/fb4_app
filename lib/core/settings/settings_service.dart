import 'dart:async';

import 'package:fb4_app/core/events/settings_changed.dart';
import 'package:kiwi/kiwi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  late SharedPreferences? _sharedPreferences;
  final StreamController _streamController = StreamController.broadcast();

  Stream<SettingsChangedEvent> get settingsChangedEvent =>
      _streamController.stream.cast<SettingsChangedEvent>();

  SettingsService() {
    _sharedPreferences = KiwiContainer().resolve<SharedPreferences>();
  }

  void saveString(String key, String value) {
    _sharedPreferences?.setString(key, value);
    _streamController
        .add(SettingsChangedEvent(settingName: key, newValue: value));
  }

  void saveBool(String key, bool value) {
    _sharedPreferences?.setBool(key, value);
    _streamController
        .add(SettingsChangedEvent(settingName: key, newValue: value));
  }

  String? getString(String key) {
    return _sharedPreferences?.getString(key);
  }

  bool? getBool(String key) {
    return _sharedPreferences?.getBool(key);
  }
}
