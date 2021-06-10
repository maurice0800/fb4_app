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

      isInitialized = true;
      notifyListeners();
    });
  }

  void acceptPrivacyPolicy() async {
    await SharedPreferences.getInstance()
        .then((s) => s.setBool(AppConstants.privacyPolicyAccepted, true));

    shouldShowPrivacyPolicy = false;
    notifyListeners();
  }
}
