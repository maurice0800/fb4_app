class SelectedCourseInfo {
  final String shortName;
  final String semester;
  late String groupLetter;
  late String groupNumber;

  SelectedCourseInfo(this.shortName, this.semester, {String groupString = ""}) {
    if (groupString != "") {
      groupLetter = groupString.substring(0, 1);
      groupNumber = groupString.substring(1);
    } else {
      groupLetter = "";
      groupNumber = "";
    }
  }
}
