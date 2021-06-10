class SelectedCourseInfo {
  final String shortName;
  final String semester;
  late String groupLetter;
  late String groupNumber;

  SelectedCourseInfo(this.shortName, this.semester, {String groupString = ""}) {
    if (groupString != "") {
      this.groupLetter = groupString.substring(0, 1);
      this.groupNumber = groupString.substring(1);
    }
  }
}
