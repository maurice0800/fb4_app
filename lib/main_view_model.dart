import 'package:fb4_app/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainViewModel extends ChangeNotifier {
  bool isInitialized = false;
  bool shouldShowPrivacyPolicy = true;

  Future init() async {
    return SharedPreferences.getInstance().then((s) {
      if (!(s.getBool(AppConstants.privacyPolicyAccepted) ?? false)) {
        shouldShowPrivacyPolicy = true;
      } else {
        shouldShowPrivacyPolicy = false;
      }

      if (s.getString(AppConstants.privacyPolicyAcceptedVersion) != "1.1") {
        shouldShowPrivacyPolicy = true;
      }

      isInitialized = true;
      notifyListeners();
    });
  }

  void acceptPrivacyPolicy() async {
    final instance = await SharedPreferences.getInstance();
    instance.setBool(AppConstants.privacyPolicyAccepted, true);
    instance.setString(AppConstants.privacyPolicyAcceptedVersion, "1.1");

    shouldShowPrivacyPolicy = false;
    notifyListeners();
  }
}
