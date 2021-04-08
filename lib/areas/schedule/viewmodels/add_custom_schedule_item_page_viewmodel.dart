import 'package:fb4_app/api_constants.dart';
import 'package:fb4_app/areas/schedule/models/schedule_item.dart';
import 'package:flutter/cupertino.dart';

class AddCustomScheduleItemPageViewModel extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController weekdayController = TextEditingController();
  TextEditingController timeBeginController = TextEditingController();
  TextEditingController timeEndController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController lecturerController = TextEditingController();
  TextEditingController shortlecturerController = TextEditingController();

  ScheduleItem createNewItem() {
    return ScheduleItem(
        name: nameController.text,
        courseType: "C",
        lecturerId: shortlecturerController.text,
        lecturerName: lecturerController.text,
        timeBegin: timeBeginController.text.replaceFirst(':', ''),
        timeEnd: timeEndController.text.replaceFirst(':', ''),
        weekday: ApiConstants.longWeekDays[weekdayController.text],
        roomId: roomController.text);
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
