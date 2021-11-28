import 'package:fb4_app/core/events/event_base.dart';

class SettingsChangedEvent implements EventBase {
  @override
  String eventName = "settingsChangedEvent";
  final String settingName;
  final dynamic newValue;

  SettingsChangedEvent({required this.settingName, required this.newValue});
}
