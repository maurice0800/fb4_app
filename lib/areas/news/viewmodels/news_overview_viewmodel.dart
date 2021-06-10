import 'dart:io';

import 'package:fb4_app/areas/news/models/news_item.dart';
import 'package:fb4_app/areas/news/repositories/news_repository.dart';
import 'package:flutter/cupertino.dart';

class NewsOverviewViewModel extends ChangeNotifier {
  NewsRepository repository = new NewsRepository();
  bool hasError = false;
  List<NewsItem> newsItems = [];
  bool isLoading = false;

  Future fetchNewsItems(
      {required Function(String) onError, bool alwaysRefresh = true}) {
    if (alwaysRefresh || newsItems.length == 0) {
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
}
