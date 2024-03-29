import 'package:intl/intl.dart';

class NewsItem {
  final String title;
  final DateTime pubDate;
  final String list;
  final String description;

  NewsItem({
    required this.title,
    required this.pubDate,
    required this.list,
    required this.description,
  });

  static String replaceSpecialChars(String input) {
    return input
        .replaceAll('\u0096', '\u2014')
        .replaceAll('\u0093', '"')
        .replaceAll('\u0094', '"')
        .replaceAll(RegExp('<[^>]*>'), '')
        .trim();
  }

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    final timeFormat = DateFormat("dd.MM.yyyy - hh:mm:ss");
    return NewsItem(
      title: json['header'].toString(),
      pubDate: timeFormat.parse(json['date'].toString()),
      description: json['body'].toString(),
      list: json['list'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final timeFormat = DateFormat("dd.MM.yyyy - hh:mm:ss");

    return {
      "header": title,
      "date": timeFormat.format(pubDate),
      "body": description,
      "list": list,
    };
  }
}
