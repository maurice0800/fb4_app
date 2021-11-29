import 'dart:convert';

import 'package:fb4_app/app_constants.dart';
import 'package:fb4_app/areas/canteen/models/canteen.dart';
import 'package:fb4_app/areas/canteen/repositories/canteens_repository.dart';
import 'package:fb4_app/core/settings/settings_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:kiwi/kiwi.dart';

class SelectCanteensPageViewModel extends ChangeNotifier {
  final CanteensRepository _canteensRepository =
      KiwiContainer().resolve<CanteensRepository>();
  final _settingsService = KiwiContainer().resolve<SettingsService>();
  List<Canteen> canteens = [];
  List<Canteen> selectedCanteens = [];

  SelectCanteensPageViewModel() {
    if (_settingsService.containsKey(AppConstants.settingsEnabledCanteens)) {
      try {
        final settingsString =
            _settingsService.getString(AppConstants.settingsEnabledCanteens);
        selectedCanteens = (jsonDecode(settingsString!) as List)
            .map((x) => Canteen.fromJson(x as Map<String, dynamic>))
            .toList();
      } finally {}
    } else {
      selectedCanteens = [];
    }
  }

  Future getAllCanteens() async {
    canteens = await _canteensRepository.getAll();
    notifyListeners();
  }

  // ignore: avoid_positional_boolean_parameters
  void setSelectedState(Canteen canteen, bool state) {
    if (state) {
      selectedCanteens.add(canteen);
    } else {
      selectedCanteens.remove(canteen);
    }

    _settingsService.saveString(
        AppConstants.settingsEnabledCanteens, jsonEncode(selectedCanteens));

    notifyListeners();
  }
}
