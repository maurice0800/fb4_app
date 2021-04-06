import 'dart:convert';
import 'dart:io';

import 'package:fb4_app/areas/news/models/news_item.dart';
import 'package:xml/xml.dart';

class NewsRepository {
  // We need to ignore https trust because FH Dortmund does not seem to care too much about using valid certificates :(
  Future<List<NewsItem>> getNewsItems() async {
    HttpClient client = HttpClient()
      ..badCertificateCallback = (cert, host, port) {
        return host == "www.inf.fh-dortmund.de" && port == 443;
      };
    return client
        .getUrl(Uri.parse('https://www.inf.fh-dortmund.de/rss.php'))
        .then((request) async {
      var result = await request.close();
      if (result.statusCode == 200) {
        var document =
            XmlDocument.parse(await result.transform(Latin1Decoder()).join());
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
