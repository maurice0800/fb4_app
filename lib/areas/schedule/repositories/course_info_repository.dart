import 'dart:convert';

import 'package:fb4_app/areas/schedule/models/course_info.dart';
import 'package:http/http.dart' as http;

class CourseInfoRepository {
  List<CourseInfo> cachedCourses = [];

  Future<List<CourseInfo>> getCourses() async {
    if (cachedCourses.isEmpty) {
      return http
          .get(
        Uri.parse(
          'https://ws.inf.fh-dortmund.de/fbws/current/rest/CourseOfStudy/?Accept=application/json',
        ),
      )
          .then((result) {
        if (result.statusCode == 200) {
          final Map data = jsonDecode(result.body) as Map;
          return cachedCourses = data.values
              .where((item) => item['grades'] != null)
              .map<CourseInfo>(
                (item) => CourseInfo.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        } else {
          return [];
        }
      });
    } else {
      return Future.value(cachedCourses);
    }
  }
}
