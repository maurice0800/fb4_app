import 'dart:convert';

import 'package:fb4_app/areas/schedule/models/course_info.dart';
import 'package:http/http.dart' as http;

class CourseInfoRepository {
  Future<List<CourseInfo>> getCourses() async {
    return http
        .get(
            'https://ws.inf.fh-dortmund.de/fbws/current/rest/CourseOfStudy/?Accept=application/json')
        .then((result) {
      if (result.statusCode == 200) {
        var data = jsonDecode(result.body) as Map;
        return data.values
            .map<CourseInfo>((item) => CourseInfo.fromJson(item))
            .toList();
      } else {
        return [];
      }
    });
  }
}
