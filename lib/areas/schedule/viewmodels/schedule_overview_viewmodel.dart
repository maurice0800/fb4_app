// ignore_for_file: avoid_function_literals_in_foreach_calls, prefer_for_elements_to_map_fromiterable

import 'dart:math';

import 'package:fb4_app/api_constants.dart';
import 'package:fb4_app/app_constants.dart';
import 'package:fb4_app/areas/schedule/models/schedule_item.dart';
import 'package:fb4_app/areas/schedule/models/schedule_list_controller.dart';
import 'package:fb4_app/areas/schedule/models/selected_course_info.dart';
import 'package:fb4_app/areas/schedule/repositories/schedule_repository.dart';
import 'package:fb4_app/areas/schedule/widgets/schedule_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_store/json_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleOverviewViewModel extends ChangeNotifier {
  final JsonStore jsonStore = JsonStore();
  final ScheduleRepository repository = ScheduleRepository();
  final ScheduleListController internalController = ScheduleListController();
  final PageController pageViewController = PageController();
  final ValueNotifier<int> controllerPageNotifier = ValueNotifier(0);
  // ignore: prefer_function_declarations_over_variables
  Function() aferNextRender = () {};
  bool editMode = false;
  bool isLoading = false;
  bool hasItems = false;
  List<ScheduleList> persistentScheduleItems = [];
  List<ScheduleList> displayScheduleItems = [];

  ScheduleOverviewViewModel() {
    getScheduleListsFromDatabase();
    internalController.onItemRemoved = (item) {
      final currentPage = pageViewController.page!.floor();
      resyncWithDatabase();
      aferNextRender = () {
        pageViewController.jumpToPage(currentPage);
        controllerPageNotifier.value = currentPage;
      };
    };

    internalController.onItemChanged = (item) {
      final currentPage = pageViewController.page!.floor();
      resyncWithDatabase();
      aferNextRender = () {
        pageViewController.jumpToPage(currentPage);
        controllerPageNotifier.value = currentPage;
      };
    };
  }

  Future getScheduleListsFromServer(SelectedCourseInfo info) async {
    isLoading = true;
    notifyListeners();

    editMode = true;
    hasItems = true;

    final items =
        await repository.getScheduleItems(info.shortName, info.semester);

    items.forEach((element) {
      element.userIsInGroup = isGroupInScheduleItem(info, element);
    });

    displayScheduleItems = List.generate(
        5,
        (index) => ScheduleList(
              items: persistentScheduleItems[index].items +
                  markListForEdit(generateListFromItems(
                      items, ApiConstants.shortWeekDayList[index])),
              weekday: AppConstants.weekdays[index],
              controller: internalController,
            ));

    displayScheduleItems.forEach((element) {
      element.items.sort();
    });

    aferNextRender = () => pageViewController.jumpToPage(0);
    isLoading = false;
    notifyListeners();
  }

  Future getScheduleListsFromDatabase() async {
    isLoading = true;
    hasItems = false;
    notifyListeners();

    final lists = await jsonStore.getListLike("schedule%") ?? [];

    if (lists.length == 5) {
      lists.forEach((element) {
        hasItems = hasItems || element.keys.isNotEmpty;
      });

      persistentScheduleItems = List.generate(
          5,
          (index) => ScheduleList(
                items: generateListFromItems(
                    lists[index]
                        .values
                        .map<ScheduleItem>((e) =>
                            ScheduleItem.fromJson(e as Map<String, dynamic>))
                        .toList(),
                    ApiConstants.shortWeekDayList[index]),
                weekday: ApiConstants.shortWeekDayList[index],
                controller: internalController,
              ));
      persistentScheduleItems.forEach((element) => element.items.sort());
      displayScheduleItems = persistentScheduleItems.toList();

      if ((await SharedPreferences.getInstance())
              .getBool(AppConstants.settingsGoToCurrentDayInSchedule) ??
          false) {
        if (!editMode) {
          aferNextRender = () =>
              pageViewController.jumpToPage(min(DateTime.now().weekday - 1, 5));
        }
      }
    } else {
      // There is an error with the database. Initializing new database structure...
      jsonStore.deleteLike("schedule%");
      persistentScheduleItems = List.generate(
          5,
          (index) => ScheduleList(
                weekday: ApiConstants.shortWeekDayList[index],
                controller: ScheduleListController(),
              ));
      await resyncWithDatabase();
    }

    lists.clear();
    isLoading = false;
    notifyListeners();
  }

  Future saveAllItemsToDatabase() async {
    jsonStore.deleteLike("schedule%");
    final batch = await jsonStore.startBatch();
    persistentScheduleItems.forEach((element) {
      final itemsMap = Map.fromIterable(
        (element.items).map((e) => e.toJson()),
        key: (item) => item.hashCode.toString(),
        value: (item) => item,
      );
      jsonStore.setItem("schedule-${element.weekday}", itemsMap);
    });

    await jsonStore.commitBatch(batch);
  }

  Future addSelectedItemsToList() async {
    if (internalController.selectedItems.isNotEmpty) {
      internalController.selectedItems.forEach((newItem) {
        persistentScheduleItems
            .firstWhere(
                (scheduleList) => scheduleList.weekday == newItem.weekday)
            .items
            .add(newItem..editMode = false);
      });
    }

    editMode = false;
    displayScheduleItems.clear();
    internalController.selectedItems.clear();

    await resyncWithDatabase();
  }

  List<ScheduleItem> generateListFromItems(
      List<ScheduleItem> items, String shortWeekday) {
    return items.where((element) => element.weekday == shortWeekday).toList();
  }

  List<ScheduleItem> markListForEdit(List<ScheduleItem> items) {
    items.forEach((element) => element.editMode = true);
    return items;
  }

  Future addCustomItem(ScheduleItem result) async {
    persistentScheduleItems
        .firstWhere((element) => element.weekday == result.weekday)
        .items
        .add(result);

    await resyncWithDatabase();
  }

  bool isGroupInScheduleItem(SelectedCourseInfo info, ScheduleItem item) {
    if (info.groupLetter == "" || info.groupLetter == "") {
      return true;
    }

    // Check if student set is valid
    if (!item.studentSet.contains("-")) {
      return info.groupNumber.codeUnitAt(0) == item.studentSet.codeUnitAt(0);
    } else {
      // Get matches from student set
      final matches = RegExp('^([A-Z])([0-9]*)-([A-Z])([0-9]*)\$')
          .allMatches(item.studentSet)
          .toList()[0];

      // When the the first letter is the same as the input letter from the user we have to check the number
      if (info.groupLetter.codeUnitAt(0) == matches.group(1)?.codeUnitAt(0)) {
        if (matches.group(2) == null || matches.group(2) == "") {
          return true;
        } else {
          return int.parse(info.groupNumber) >=
              int.parse(matches.group(2).toString());
        }
      }

      // Also check the last letter
      if (info.groupLetter.codeUnitAt(0) == matches.group(3)?.codeUnitAt(0)) {
        if (matches.group(4) == null || matches.group(4) == "") {
          return true;
        } else {
          return int.parse(info.groupNumber) <=
              int.parse(matches.group(4).toString());
        }
      }

      // Just check letters because the number does not matter when the given letter is inbetween the student set
      if (info.groupLetter.codeUnitAt(0) > matches.group(1)!.codeUnitAt(0)) {
        if (info.groupLetter.codeUnitAt(0) < matches.group(3)!.codeUnitAt(0)) {
          return true;
        }
      }
    }

    return false;
  }

  Future resyncWithDatabase() async {
    await saveAllItemsToDatabase();
    await getScheduleListsFromDatabase();
  }

  Future deleteItemFromDatabase(ScheduleItem item) async {
    persistentScheduleItems.forEach((element) {
      element.items.remove(item);
    });
  }
}
