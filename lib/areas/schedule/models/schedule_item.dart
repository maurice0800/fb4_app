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
  bool userIsInGroup = true;
  bool editMode;
  Color color;

  ScheduleItem({
    required this.name,
    required this.courseType,
    required this.lecturerId,
    required this.lecturerName,
    this.studentSet = "",
    required this.timeBegin,
    required this.timeEnd,
    required this.weekday,
    required this.roomId,
    this.editMode = false,
    this.color = ColorConsts.mainOrange,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    final color = json['color'];

    return ScheduleItem(
      name: json['name'].toString(),
      courseType: json['courseType'].toString(),
      lecturerId: json['lecturerId'].toString(),
      lecturerName: json['lecturerName'].toString(),
      studentSet: json['studentSet'].toString(),
      timeBegin: json['timeBegin'].toString().padLeft(4, '0'),
      timeEnd: json['timeEnd'].toString().padLeft(4, '0'),
      weekday: json['weekday'].toString(),
      roomId: json['roomId'].toString(),
      color: color != null
          ? Color(int.parse(color.toString()))
          : ColorConsts.mainOrange,
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
      return other.hashCode == hashCode;
    }
    return false;
  }

  @override
  int compareTo(dynamic other) =>
      int.parse(timeBegin) - int.parse(other.timeBegin.toString());
}
