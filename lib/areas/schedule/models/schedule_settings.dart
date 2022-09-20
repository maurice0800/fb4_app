class ScheduleSettings {
  String courseIdentifier;
  String groupIdentifier;

  ScheduleSettings({
    required this.courseIdentifier,
    required this.groupIdentifier,
  });

  factory ScheduleSettings.fromJson(Map<String, dynamic> json) {
    return ScheduleSettings(
      groupIdentifier: json['groupIdentifier'].toString(),
      courseIdentifier: json['courseIdentifier'].toString(),
    );
  }
}
