import 'dart:convert';
import 'dart:io';

import 'package:fb4_app/app_constants.dart';
import 'package:fb4_app/areas/news/models/news_item.dart';
import 'package:fb4_app/areas/news/repositories/news_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsOverviewViewModel extends ChangeNotifier {
  NewsRepository repository = new NewsRepository();
  bool hasError = false;
  List<NewsItem> newsItems = [];
  List<NewsItem> pinnedItems = [];
  bool isLoading = false;

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

  Future pinNewsItem(NewsItem item) async {
    pinnedItems.add(item);
    await _savePinnedItemsCache();
    notifyListeners();
  }

  Future unpinNewsItem(int index) async {
    pinnedItems.removeAt(index);
    await _savePinnedItemsCache();
    notifyListeners();
  }

  Future _savePinnedItemsCache() async {
    final s = await SharedPreferences.getInstance();
    s.setString(AppConstants.pinnedNewsItems,
        jsonEncode(pinnedItems.map((e) => e.toJson()).toList()));
  }

  Future loadPinnedItemsCache() async {
    if (pinnedItems.isEmpty) {
      final s = await SharedPreferences.getInstance();

      if (s.containsKey(AppConstants.pinnedNewsItems)) {
        final itemsMap = jsonDecode(s.getString(AppConstants.pinnedNewsItems)!)
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
