class CourseInfo {
  final String name;
  final String shortName;
  final List<String> grades;

  CourseInfo({this.name, this.shortName, this.grades});

  factory CourseInfo.fromJson(Map<String, dynamic> json) {
    var lul = (json['grades']);
    return CourseInfo(
        name: json['name'],
        shortName: json['sname'],
        grades: json['grades']
            .map<String>((grade) => grade['grade'].toString())
            .toList());
  }
}
