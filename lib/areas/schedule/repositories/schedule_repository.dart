import 'dart:convert';

import 'package:fb4_app/areas/schedule/models/schedule_item.dart';
import 'package:http/http.dart' as http;

class ScheduleRepository {
  Future<List<ScheduleItem>> getScheduleItems(
      String semester, String grade) async {
    return http
        .get(Uri.parse(
            'https://ws.inf.fh-dortmund.de/fbws/current/rest/CourseOfStudy/$semester/$grade/Events?Accept=application/json&studentSet=*'))
        .then((result) {
      if (result.statusCode == 200) {
        final data = jsonDecode(result.body);
        final List<ScheduleItem> items = data
            .map<ScheduleItem>(
                (item) => ScheduleItem.fromJson(item as Map<String, dynamic>))
            .toList() as List<ScheduleItem>;
        return items;
      } else {
        return [];
      }
    });
  }
}
