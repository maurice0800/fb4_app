import 'package:intl/intl.dart';

class NewsItem {
  final String title;
  final DateTime pubDate;
  final String list;
  final String description;

  NewsItem({this.title, this.pubDate, this.list, this.description});

  static String replaceSpecialChars(String input) {
    return input
        .replaceAll('\u0096', '\u2014')
        .replaceAll('\u0093', '"')
        .replaceAll('\u0094', '"')
        .replaceAll(new RegExp('<[^>]*>'), '')
        .trim();
  }

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    var timeFormat = DateFormat("dd.MM.yyyy - hh:mm:ss");
    return NewsItem(
        title: json['header'],
        pubDate: timeFormat.parse(json['date']),
        description: json['body'],
        list: json['list']);
  }
}
