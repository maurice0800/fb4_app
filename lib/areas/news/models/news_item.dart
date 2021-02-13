import 'package:fb4_app/utils/helpers/string_filters.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

class NewsItem {
  final String title;
  final DateTime pubDate;
  final String description;

  NewsItem({this.title, this.pubDate, this.description});

  static String replaceSpecialChars(String input) {
    return input
        .replaceAll('\u0096', '\u2014')
        .replaceAll('\u0093', '"')
        .replaceAll('\u0094', '"')
        .replaceAll(new RegExp('<[^>]*>'), '')
        .trim();
  }

  factory NewsItem.fromXmlElement(XmlElement element) {
    var timeFormat = DateFormat("EEE, dd MMM yyyy hh:mm:ss");
    return NewsItem(
        title: replaceSpecialChars(element.findElements('title').first.text),
        pubDate: timeFormat.parse(element
            .findElements('pubDate')
            .first
            .text
            .replaceFirst('+0100', '')),
        description: replaceSpecialChars(
            element.findElements('description').first.text));
  }
}
