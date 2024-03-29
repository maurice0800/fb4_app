import 'dart:async';
import 'dart:convert';

import 'package:fb4_app/app_constants.dart';
import 'package:fb4_app/areas/canteen/models/canteen.dart';
import 'package:fb4_app/areas/canteen/models/meal.dart';
import 'package:fb4_app/areas/canteen/repositories/canteens_repository.dart';
import 'package:fb4_app/areas/canteen/repositories/meals_repository.dart';
import 'package:fb4_app/core/settings/settings_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:kiwi/kiwi.dart';

class CanteenOverviewViewModel extends ChangeNotifier {
  late List<String> enabledCanteenIds;
  late List<Canteen> allCanteens;
  late final MealsRepository _mealsRepository;
  late final CanteensRepository _canteensRepository;
  late final ValueNotifier<DateTime> currentDate =
      ValueNotifier<DateTime>(DateTime.now());
  late final PageController pageController;
  late final SettingsService _settingsService;

  CanteenOverviewViewModel() {
    _settingsService = KiwiContainer().resolve<SettingsService>();
    _mealsRepository = KiwiContainer().resolve<MealsRepository>();
    _canteensRepository = KiwiContainer().resolve<CanteensRepository>();
    pageController = PageController(initialPage: 7);
    allCanteens = _canteensRepository.getAll();

    _settingsService.settingsChangedEvent.listen((e) {
      if (e.settingName == AppConstants.settingsEnabledCanteens) {
        loadEnabledCanteensFromSettings();
      }
    });

    loadEnabledCanteensFromSettings();
  }

  Future<Map<Canteen, List<Meal>>> getMealsForCanteensAtDateIndex(
    int index,
  ) async {
    final dateOffset = index - 7;
    final dateString = DateFormat("yyyy-MM-dd")
        .format(DateTime.now().add(Duration(days: dateOffset)));

    final returnMap = <Canteen, List<Meal>>{};

    for (final id in enabledCanteenIds) {
      final canteen = allCanteens.firstWhere((element) => element.id == id);
      returnMap[canteen] =
          await _mealsRepository.getMealsForCanteen(canteen, dateString);
    }

    return returnMap;
  }

  void loadEnabledCanteensFromSettings() {
    if (_settingsService.containsKey(AppConstants.settingsEnabledCanteens)) {
      try {
        final settingsString =
            _settingsService.getString(AppConstants.settingsEnabledCanteens);
        enabledCanteenIds = (jsonDecode(settingsString!) as List)
            .map((e) => e.toString())
            .toList();
      } finally {}
    } else {
      enabledCanteenIds = [];
    }

    notifyListeners();
  }

  void onSelectedDateChanged(DateTime newDate) {
    if (newDate.difference(currentDate.value).isNegative) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear,
      );
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear,
      );
    }
  }

  void onPageSwiped(int newPage) {
    if (pageController.page! < newPage) {
      currentDate.value = currentDate.value.add(const Duration(days: 1));
    } else {
      currentDate.value = currentDate.value.subtract(const Duration(days: 1));
    }
  }
}
