class ApiConstants {
  static final String shortMonday = "Mon";
  static final String shortTuesday = "Tue";
  static final String shortWednesday = "Wed";
  static final String shortThursday = "Thu";
  static final String shortFriday = "Fri";

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
