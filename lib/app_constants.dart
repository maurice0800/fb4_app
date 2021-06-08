class AppConstants {
  static final List<String> weekdays = [
    "Montag",
    "Dienstag",
    "Mittwoch",
    "Donnerstag",
    "Freitag",
  ];

  static final Map<String, int> routeNames = {
    "schedule": 0,
    "news": 1,
    "canteen": 2,
    "ticket": 3,
    "more": 4,
  };

  static const settingsIncreaseDisplayBrightnessInTicketview =
      "increaseDisplayBrightnessInTicketView";

  static const settingsNotificationOnNews = "notificationOnNews";

  static const privacyPolicyAccepted = "privacyPolicyAccepted";

  static const quickActionTicket = "quickActionTicket";

  static const settingsGoToCurrentDayInSchedule = "goToCurrentDayInSchedule";
}
