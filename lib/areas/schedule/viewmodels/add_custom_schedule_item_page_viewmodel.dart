import 'package:fb4_app/api_constants.dart';
import 'package:fb4_app/areas/schedule/models/schedule_item.dart';
import 'package:flutter/cupertino.dart';

class AddCustomScheduleItemPageViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController weekdayController = TextEditingController();
  final TextEditingController timeBeginController = TextEditingController();
  final TextEditingController timeEndController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController lecturerController = TextEditingController();
  final TextEditingController shortlecturerController = TextEditingController();

  ScheduleItem createNewItem() {
    return ScheduleItem(
        name: nameController.text,
        courseType: "C",
        lecturerId: shortlecturerController.text,
        lecturerName: lecturerController.text,
        timeBegin: timeBeginController.text.replaceFirst(':', ''),
        timeEnd: timeEndController.text.replaceFirst(':', ''),
        weekday: ApiConstants.longWeekDays[weekdayController.text]!,
        roomId: roomController.text);
  }

  bool validate() {
    return (nameController.text.length > 0 &&
        weekdayController.text.length > 0 &&
        timeBeginController.text.length > 0 &&
        timeEndController.text.length > 0 &&
        roomController.text.length > 0 &&
        lecturerController.text.length > 0 &&
        shortlecturerController.text.length > 0);
  }

  void setTimeBegin(DateTime time) {
    timeBeginController.text = time.hour.toString().padLeft(2, '0') +
        ":" +
        time.minute.toString().padLeft(2, '0');
  }

  void setTimeEnd(DateTime time) {
    timeEndController.text = time.hour.toString().padLeft(2, '0') +
        ":" +
        time.minute.toString().padLeft(2, '0');
  }
}
