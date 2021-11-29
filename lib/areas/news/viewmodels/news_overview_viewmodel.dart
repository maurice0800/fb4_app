import 'dart:convert';
import 'dart:io';

import 'package:fb4_app/app_constants.dart';
import 'package:fb4_app/areas/news/models/news_item.dart';
import 'package:fb4_app/areas/news/repositories/news_repository.dart';
import 'package:fb4_app/core/settings/settings_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:kiwi/kiwi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsOverviewViewModel extends ChangeNotifier {
  NewsRepository repository = NewsRepository();
  late final SettingsService _settingsService;
  bool hasError = false;
  List<NewsItem> newsItems = [];
  List<NewsItem> pinnedItems = [];
  bool isLoading = false;

  NewsOverviewViewModel() {
    _settingsService = KiwiContainer().resolve<SettingsService>();
  }

  Future fetchNewsItems(
      {required Function(String) onError, bool alwaysRefresh = true}) {
    if ((alwaysRefresh || newsItems.isEmpty) && !hasError) {
      isLoading = true;
      notifyListeners();

      return repository.getNewsItems().then((items) {
        newsItems = items;
        hasError = false;
        notifyListeners();
      }).onError((error, stackTrace) {
        if (error is SocketException) {
          onError("Verbindung zum Server fehlgeschlagen.");
        } else {
          onError(error.toString());
        }
        hasError = true;
        notifyListeners();
      }).whenComplete(() => isLoading = false);
    }

    return Future.value();
  }

  void pinNewsItem(NewsItem item) {
    pinnedItems.add(item);
    _savePinnedItemsCache();
    notifyListeners();
  }

  void unpinNewsItem(int index) {
    pinnedItems.removeAt(index);
    _savePinnedItemsCache();
    notifyListeners();
  }

  void _savePinnedItemsCache() {
    _settingsService.saveString(AppConstants.pinnedNewsItems,
        jsonEncode(pinnedItems.map((e) => e.toJson()).toList()));
  }

  void loadPinnedItemsCache() {
    if (pinnedItems.isEmpty) {
      if (_settingsService.containsKey(AppConstants.pinnedNewsItems)) {
        final itemsMap = jsonDecode(
                _settingsService.getString(AppConstants.pinnedNewsItems)!)
            as List<dynamic>;

        if (itemsMap.isNotEmpty) {
          pinnedItems = itemsMap
              .map<NewsItem>(
                  (e) => NewsItem.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
    }
  }
}
