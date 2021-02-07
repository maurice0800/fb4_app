import 'dart:convert';

import 'package:fb4_app/areas/schedule/models/schedule_item.dart';
import 'package:http/http.dart' as http;

class ScheduleRepository {
  Future<List<ScheduleItem>> getScheduleItems(
      String semester, String grade) async {
    return http
        .get(
            'https://ws.inf.fh-dortmund.de/fbws/current/rest/CourseOfStudy/$semester/$grade/Events?Accept=application/json&studentSet=*')
        .then((result) {
      if (result.statusCode == 200) {
        var data = jsonDecode(result.body);
        List<ScheduleItem> items = data
            .map<ScheduleItem>((item) => ScheduleItem.fromJson(item))
            .toList();
        return items;
      }
    });
  }
}
