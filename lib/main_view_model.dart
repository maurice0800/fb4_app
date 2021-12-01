import 'package:fb4_app/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'core/settings/settings_service.dart';

class MainViewModel extends ChangeNotifier {
  late final SettingsService _settingsService;
  bool shouldShowPrivacyPolicy = true;

  MainViewModel() {
    _settingsService = KiwiContainer().resolve<SettingsService>();

    shouldShowPrivacyPolicy =
        !(_settingsService.getBool(AppConstants.privacyPolicyAccepted) ??
            false);

    if (_settingsService.getString(AppConstants.privacyPolicyAcceptedVersion) !=
        "1.2") {
      shouldShowPrivacyPolicy = true;
    }
  }

  void acceptPrivacyPolicy() {
    _settingsService.saveBool(AppConstants.privacyPolicyAccepted, true);
    _settingsService.saveString(
        AppConstants.privacyPolicyAcceptedVersion, "1.2");

    shouldShowPrivacyPolicy = false;
    notifyListeners();
  }
}
