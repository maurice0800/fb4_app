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
  List<String> selectedCanteenIds = [];

  SelectCanteensPageViewModel() {
    if (_settingsService.containsKey(AppConstants.settingsEnabledCanteens)) {
      try {
        final settingsString =
            _settingsService.getString(AppConstants.settingsEnabledCanteens);
        selectedCanteenIds = (jsonDecode(settingsString!) as List)
            .map((e) => e.toString())
            .toList();
      } finally {}
    } else {
      selectedCanteenIds = [];
    }
  }

  Future getAllCanteens() async {
    canteens = _canteensRepository.getAll();
    notifyListeners();
  }

  // ignore: avoid_positional_boolean_parameters
  void setSelectedState(Canteen canteen, bool state) {
    if (state) {
      selectedCanteenIds.add(canteen.id);
    } else {
      selectedCanteenIds.remove(canteen.id);
    }

    _settingsService.saveString(
      AppConstants.settingsEnabledCanteens,
      jsonEncode(selectedCanteenIds),
    );

    notifyListeners();
  }
}
