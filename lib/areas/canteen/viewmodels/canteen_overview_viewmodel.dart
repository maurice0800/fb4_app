import 'dart:async';
import 'dart:convert';

import 'package:fb4_app/app_constants.dart';
import 'package:fb4_app/areas/canteen/models/canteen.dart';
import 'package:fb4_app/areas/canteen/models/meal.dart';
import 'package:fb4_app/areas/canteen/repositories/meals_repository.dart';
import 'package:fb4_app/areas/more/viewmodels/select_canteens_page_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:kiwi/kiwi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CanteenOverviewViewModel extends ChangeNotifier {
  late List<Canteen> enabledCanteens;
  late MealsRepository _mealsRepository;
  late ValueNotifier<DateTime> currentDate =
      ValueNotifier<DateTime>(DateTime.now());
  late PageController pageController;

  CanteenOverviewViewModel() {
    enabledCanteens =
        KiwiContainer().resolve<SelectCanteensPageViewModel>().selectedCanteens;

    _mealsRepository = KiwiContainer().resolve<MealsRepository>();

    pageController = PageController(initialPage: 7);
  }

  Future<Map<Canteen, List<Meal>>> getMealsForCanteensAtDateIndex(
      int index) async {
    final dateOffset = index - 7;
    final dateString = DateFormat("yyyy-MM-dd")
        .format(DateTime.now().add(Duration(days: dateOffset)));

    final returnMap = <Canteen, List<Meal>>{};

    for (final c in enabledCanteens) {
      returnMap[c] = await _mealsRepository.getMealsForCanteen(c, dateString);
    }

    return returnMap;
  }

  void loadEnabledCanteensFromSettings() {
    final settings = KiwiContainer().resolve<SharedPreferences>();

    if (settings.containsKey(AppConstants.settingsEnabledCanteens)) {
      try {
        final settingsString =
            settings.getString(AppConstants.settingsEnabledCanteens);
        enabledCanteens = jsonDecode(settingsString!) as List<Canteen>;
      } finally {}
    }

    notifyListeners();
  }

  void onSelectedDateChanged(DateTime newDate) {
    if (newDate.difference(currentDate.value).isNegative) {
      pageController.previousPage(
          duration: const Duration(milliseconds: 200), curve: Curves.linear);
    } else {
      pageController.nextPage(
          duration: const Duration(milliseconds: 200), curve: Curves.linear);
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
