import 'package:fb4_app/utils/helpers/string_filters.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

class NewsItem {
  final String title;
  final DateTime pubDate;
  final String description;

  NewsItem({this.title, this.pubDate, this.description});

  factory NewsItem.fromXmlElement(XmlElement element) {
    var timeFormat = DateFormat("EEE, dd MMM yyyy hh:mm:ss");
    return NewsItem(
        title: element.findElements('title').first.text.trim(),
        pubDate: timeFormat.parse(element
            .findElements('pubDate')
            .first
            .text
            .replaceFirst('+0100', '')),
        description: element
            .findElements('description')
            .first
            .text
            .replaceAll('<br />', '')
            .replaceAll(new RegExp('<[^>]*>'), '')
            .trim());
  }
}
