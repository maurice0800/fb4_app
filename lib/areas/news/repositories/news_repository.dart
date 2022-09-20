import 'dart:convert';

import 'package:fb4_app/areas/news/models/news_item.dart';
import 'package:http/http.dart' as http;

class NewsRepository {
  // We need to ignore https trust because FH Dortmund does not seem to care too much about using valid certificates :(
  Future<List<NewsItem>> getNewsItems() async {
    return http
        .get(Uri.parse('https://fb4app.hemacode.de/getNews.php'))
        .then((result) {
      if (result.statusCode == 200) {
        final data = jsonDecode(utf8.decode(result.bodyBytes));
        final List<NewsItem> items = data
            .map<NewsItem>(
              (item) => NewsItem.fromJson(item as Map<String, dynamic>),
            )
            .toList() as List<NewsItem>;
        return items;
      } else {
        return [];
      }
    });
  }
}
