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
  List<ScheduleList> scheduleDays = List<ScheduleList>();

  void getScheduleListsFromServer(SelectedCourseInfo info) {
    isLoading = true;
    notifyListeners();

    editMode = true;

    repository
        .getScheduleItems(info.shortName, info.semester)
        .then((List<ScheduleItem> items) {
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
    });
  }

  void getScheduleListsFromCache() {
    isLoading = true;
    notifyListeners();

    jsonStore.getItem("schedule_items").then((itemsList) {
      if (itemsList == null) {
        return;
      } else {
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

        isLoading = false;
        notifyListeners();
      }
    });
  }

  void saveSelectedItemsToCache() {
    isLoading = true;
    notifyListeners();

    var itemsMap = Map.fromIterable(
        internalController.selectedItems.map((e) => e.toJson()),
        key: (item) => ScheduleItem.fromJson(item).hashCode.toString(),
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
