import 'package:quiver/core.dart';

class ScheduleItem {
  final String name;
  final String courseType;
  final String lecturerId;
  final String lecturerName;
  final String studentSet;
  final String timeBegin;
  final String timeEnd;
  final String weekday;
  final String roomId;

  ScheduleItem(
      {this.name,
      this.courseType,
      this.lecturerId,
      this.lecturerName,
      this.studentSet,
      this.timeBegin,
      this.timeEnd,
      this.weekday,
      this.roomId});

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
        name: json['name'],
        courseType: json['courseType'],
        lecturerId: json['lecturerId'],
        lecturerName: json['lecturerName'],
        studentSet: json['studentSet'],
        timeBegin: json['timeBegin'].toString().padLeft(4, '0'),
        timeEnd: json['timeEnd'].toString().padLeft(4, '0'),
        weekday: json['weekday'],
        roomId: json['roomId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'courseType': courseType,
      'lecturerId': lecturerId,
      'lecturerName': lecturerName,
      'studentSet': studentSet,
      'timeBegin': timeBegin,
      'timeEnd': timeEnd,
      'weekday': weekday,
      'roomId': roomId,
    };
  }

  @override
  int get hashCode {
    return hash4(name, lecturerName, timeBegin, weekday);
  }

  @override
  bool operator ==(Object other) {
    if (other is ScheduleItem) {
      return other.hashCode == this.hashCode;
    }
    return false;
  }
}
