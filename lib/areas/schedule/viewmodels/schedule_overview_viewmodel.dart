import 'package:fb4_app/api_constants.dart';
import 'package:fb4_app/app_constants.dart';
import 'package:fb4_app/areas/schedule/models/schedule_item.dart';
import 'package:fb4_app/areas/schedule/models/schedule_list_controller.dart';
import 'package:fb4_app/areas/schedule/models/selected_course_info.dart';
import 'package:fb4_app/areas/schedule/repositories/schedule_repository.dart';
import 'package:fb4_app/areas/schedule/widgets/schedule_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_store/json_store.dart';

class ScheduleOverviewViewModel extends ChangeNotifier {
  JsonStore jsonStore = JsonStore();
  bool editMode = false;
  bool isLoading = false;
  ScheduleRepository repository = ScheduleRepository();
  ScheduleListController internalController = ScheduleListController();
  List<ScheduleList> scheduleDays = [];

  ScheduleOverviewViewModel() {
    getScheduleListsFromCache();
    internalController.onItemRemoved = (item) {
      getScheduleListsFromCache();
    };
  }

  void getScheduleListsFromServer(SelectedCourseInfo info) async {
    isLoading = true;
    notifyListeners();

    editMode = true;

    var items =
        await repository.getScheduleItems(info.shortName, info.semester);

    items.forEach((element) {
      element.userIsInGroup = isGroupInScheduleItem(info, element);
    });

    scheduleDays = new List.generate(
        5,
        (index) => ScheduleList(
              items: getListFromItems(items, ApiConstants.weekDayList[index]),
              weekday: AppConstants.weekdays[index],
              controller: internalController,
              editMode: editMode,
            ));
    isLoading = false;
    notifyListeners();
  }

  bool isGroupInScheduleItem(SelectedCourseInfo info, ScheduleItem item) {
    if (info.groupLetter == "" || info.groupLetter == null) {
      return true;
    }

    // Check if student set is valid
    if (!item.studentSet.contains("-")) {
      return info.groupNumber.codeUnitAt(0) == item.studentSet.codeUnitAt(0);
    } else {
      // Get matches from student set
      var matches = RegExp('^([A-Z])([0-9]*)-([A-Z])([0-9]*)\$')
          .allMatches(item.studentSet)
          .toList()[0];

      // When the the first letter is the same as the input letter from the user we have to check the number
      if (info.groupLetter.codeUnitAt(0) == matches.group(1).codeUnitAt(0)) {
        if (matches.group(2) == null || matches.group(2) == "") {
          return true;
        } else {
          return int.parse(info.groupNumber) >= int.parse(matches.group(2));
        }
      }

      // Also check the last letter
      if (info.groupLetter.codeUnitAt(0) == matches.group(3).codeUnitAt(0)) {
        if (matches.group(4) == null || matches.group(4) == "") {
          return true;
        } else {
          return int.parse(info.groupNumber) <= int.parse(matches.group(4));
        }
      }

      // Just check letters because the number does not matter when the given letter is inbetween the student set
      if (info.groupLetter.codeUnitAt(0) > matches.group(1).codeUnitAt(0)) {
        if (info.groupLetter.codeUnitAt(0) < matches.group(3).codeUnitAt(0)) {
          return true;
        }
      }
    }

    return false;
  }

  void getScheduleListsFromCache() {
    isLoading = true;
    notifyListeners();
    scheduleDays.clear();

    jsonStore.getItem("schedule_items").then((itemsList) {
      if (itemsList != null) {
        var scheduleItems = itemsList.values
            .map<ScheduleItem>((item) => ScheduleItem.fromJson(item))
            .toList();

        scheduleDays = new List.generate(
            5,
            (index) => ScheduleList(
                  items: getListFromItems(
                      scheduleItems, ApiConstants.weekDayList[index]),
                  weekday: AppConstants.weekdays[index],
                  controller: internalController,
                  editMode: editMode,
                ));
      }

      isLoading = false;
      notifyListeners();
    });
  }

  void saveSelectedItemsToCache() {
    isLoading = true;
    notifyListeners();

    var itemsMap = Map.fromIterable(
        internalController.selectedItems.map((e) => e.toJson()),
        key: (item) => item.hashCode.toString(),
        value: (item) => item);

    jsonStore.setItem("schedule_items", itemsMap).then((result) => {
          getScheduleListsFromCache(),
          editMode = false,
          isLoading = false,
          notifyListeners(),
        });

    internalController.selectedItems.clear();
  }

  List<ScheduleItem> getListFromItems(
      List<ScheduleItem> items, String shortWeekday) {
    return items.where((element) => element.weekday == shortWeekday).toList();
  }
}
