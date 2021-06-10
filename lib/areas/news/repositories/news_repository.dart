import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fb4_app/areas/news/models/news_item.dart';

class NewsRepository {
  // We need to ignore https trust because FH Dortmund does not seem to care too much about using valid certificates :(
  Future<List<NewsItem>> getNewsItems() async {
    return http.get('https://fb4app.hemacode.de/getNews.php').then((result) {
      if (result.statusCode == 200) {
        var data = jsonDecode(utf8.decode(result.bodyBytes));
        List<NewsItem> items = data
            .map<NewsItem>(
                (item) => NewsItem.fromJson(item as Map<String, dynamic>))
            .toList() as List<NewsItem>;
        return items;
      } else {
        return [];
      }
    });
  }
}
