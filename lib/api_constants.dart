class ApiConstants {
  static const String shortMonday = "Mon";
  static const String shortTuesday = "Tue";
  static const String shortWednesday = "Wed";
  static const String shortThursday = "Thu";
  static const String shortFriday = "Fri";

  static final List<String> shortWeekDayList = [
    shortMonday,
    shortTuesday,
    shortWednesday,
    shortThursday,
    shortFriday
  ];

  static final Map<String, String> longWeekDays = {
    "Montag": shortMonday,
    "Dienstag": shortTuesday,
    "Mittwoch": shortWednesday,
    "Donnerstag": shortThursday,
    "Freitag": shortFriday,
  };
}
