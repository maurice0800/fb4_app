import 'package:fb4_app/app_constants.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:quiver/core.dart';

class ScheduleItem implements Comparable {
  String name;
  String courseType;
  String lecturerId;
  String lecturerName;
  String studentSet;
  String timeBegin;
  String timeEnd;
  String weekday;
  String roomId;
  bool userIsInGroup;
  bool editMode;
  Color color = ColorConsts.mainOrange;

  ScheduleItem(
      {this.name,
      this.courseType,
      this.lecturerId,
      this.lecturerName,
      this.studentSet,
      this.timeBegin,
      this.timeEnd,
      this.weekday,
      this.roomId,
      this.editMode = false,
      this.color});

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
      roomId: json['roomId'],
      color: Color(json['color'] ?? ColorConsts.mainOrange.value),
    );
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
      'color': color.value,
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

  @override
  int compareTo(other) =>
      int.parse(this.timeBegin) - int.parse(other.timeBegin);
}
