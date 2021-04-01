import 'package:fb4_app/areas/news/models/news_item.dart';
import 'package:fb4_app/areas/news/repositories/news_repository.dart';
import 'package:flutter/cupertino.dart';

class NewsOverviewViewModel extends ChangeNotifier {
  NewsRepository repository = new NewsRepository();
  List<NewsItem> newsItems = [];

  Future fetchNewsItems() {
    return repository.getNewsItems().then((items) {
      newsItems = items;
      notifyListeners();
    });
  }
}
