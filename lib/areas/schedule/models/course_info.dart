class CourseInfo {
  final String name;
  final String shortName;
  final List<String> grades;

  CourseInfo({
    required this.name,
    required this.shortName,
    required this.grades,
  });

  factory CourseInfo.fromJson(Map<String, dynamic> json) {
    return CourseInfo(
      name: json['name'].toString(),
      shortName: json['sname'].toString(),
      grades: json['grades']
          .map<String>((grade) => grade['grade'].toString())
          .toList() as List<String>,
    );
  }
}
