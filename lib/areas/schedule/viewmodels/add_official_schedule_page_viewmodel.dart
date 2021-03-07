import 'package:fb4_app/areas/schedule/models/course_info.dart';
import 'package:fb4_app/areas/schedule/repositories/course_info_repository.dart';
import 'package:flutter/cupertino.dart';

class AddOfficialSchedulePageViewModel extends ChangeNotifier {
  CourseInfoRepository repository = CourseInfoRepository();
  List<CourseInfo> courses = [];

  CourseInfo _selectedCourse;
  String _selectedGroup;
  String _selectedSemester = "";

  TextEditingController courseController = TextEditingController();
  TextEditingController semesterController = TextEditingController();
  TextEditingController groupController = TextEditingController();

  set selectedCourse(CourseInfo info) {
    _selectedCourse = info;
    courseController.text = info.name;
  }

  CourseInfo get selectedCourse => _selectedCourse;

  set selectedGroup(String group) {
    _selectedGroup = group;
    groupController.text = group;
  }

  String get selectedGroup => _selectedGroup;

  set selectedSemester(String semester) {
    _selectedSemester = semester;
    semesterController.text = semester;
  }

  String get selectedSemester => _selectedSemester;

  void init() {
    repository.getCourses().then((courses) {
      this.courses = courses;
      notifyListeners();
    });
  }
}
