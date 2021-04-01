import 'package:fb4_app/areas/news/models/news_item.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class NewsRepository {
  Future<List<NewsItem>> getNewsItems() async {
    return http.get('https://www.inf.fh-dortmund.de/rss.php').then((result) {
      if (result.statusCode == 200) {
        var document = XmlDocument.parse(result.body);
        var items = document.findAllElements('item');
        return items
            .map<NewsItem>((element) => NewsItem.fromXmlElement(element))
            .toList();
      } else {
        throw Exception("Unexpected answer from API.");
      }
    });
  }
}
