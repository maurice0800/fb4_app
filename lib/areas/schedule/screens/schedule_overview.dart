import 'package:fb4_app/api_constants.dart';
import 'package:fb4_app/areas/schedule/bloc/course_info_bloc.dart';
import 'package:fb4_app/areas/schedule/bloc/schedule_item_bloc.dart';
import 'package:fb4_app/areas/schedule/bloc/schedule_item_event.dart';
import 'package:fb4_app/areas/schedule/bloc/schedule_item_state.dart';
import 'package:fb4_app/areas/schedule/models/schedule_item.dart';
import 'package:fb4_app/areas/schedule/models/schedule_list_controller.dart';
import 'package:fb4_app/areas/schedule/models/selected_course_info.dart';
import 'package:fb4_app/areas/schedule/repositories/course_info_repository.dart';
import 'package:fb4_app/areas/schedule/screens/add_official_schedule_page.dart';
import 'package:fb4_app/areas/schedule/screens/schedule_settings_page.dart';
import 'package:fb4_app/areas/schedule/widgets/schedule_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_store/json_store.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../app_constants.dart';

class ScheduleOverview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScheduleOverviewState();
  }
}

class ScheduleOverviewState extends State<ScheduleOverview> {
  ScrollDirection currentScrollDirection;
  bool editMode = false;
  final PageController pageViewController = PageController();
  final ItemScrollController itemScrollController = ItemScrollController();
  ValueNotifier controllerPageNotifier = ValueNotifier(0);
  ScheduleListController scheduleListController;

  ScheduleItemBloc scheduleItemBloc;

  @override
  void initState() {
    super.initState();

    scheduleListController = ScheduleListController(
        handleItemSelected, handleItemDeselected, handleItemRemoved, null);
    scheduleItemBloc = BlocProvider.of<ScheduleItemBloc>(context);
    scheduleItemBloc.add(FetchScheduleItemsFromLocalStorageEvent());
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: buildNavigationBar(),
        child: SafeArea(
          child: Container(
            child: BlocBuilder<ScheduleItemBloc, ScheduleItemState>(
              builder: (context, state) {
                if (state is ScheduleItemLoadingState ||
                    state is ScheduleItemInitialState) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ScheduleItemLoadedState) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 35,
                        child: ValueListenableBuilder(
                          valueListenable: controllerPageNotifier,
                          builder: (context, value, _) =>
                              ScrollablePositionedList.separated(
                            itemCount: AppConstants.weekdays.length,
                            itemScrollController: itemScrollController,
                            separatorBuilder: (context, index) => SizedBox(),
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 8.0, right: 10.0),
                              child: GestureDetector(
                                onTap: () => scrollClickedPageIntoView(index),
                                child: Text(AppConstants.weekdays[index],
                                    style: TextStyle(
                                        color: index ==
                                                controllerPageNotifier.value
                                            ? CupertinoTheme.of(context)
                                                .textTheme
                                                .textStyle
                                                .color
                                            : CupertinoColors.systemGrey,
                                        fontSize: 23,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ),
                      Expanded(
                        child: PageView(
                            controller: pageViewController,
                            onPageChanged: handlePageChanged,
                            children: <Widget>[
                              ScheduleList(
                                  editMode: editMode,
                                  controller: scheduleListController,
                                  items: state.scheduleItems
                                      .where((element) =>
                                          element.weekday ==
                                          ApiConstants.shortMonday)
                                      .toList()),
                              ScheduleList(
                                  editMode: editMode,
                                  controller: scheduleListController,
                                  items: state.scheduleItems
                                      .where((element) =>
                                          element.weekday ==
                                          ApiConstants.shortTuesday)
                                      .toList()),
                              ScheduleList(
                                  editMode: editMode,
                                  controller: scheduleListController,
                                  items: state.scheduleItems
                                      .where((element) =>
                                          element.weekday ==
                                          ApiConstants.shortWednesday)
                                      .toList()),
                              ScheduleList(
                                  editMode: editMode,
                                  controller: scheduleListController,
                                  items: state.scheduleItems
                                      .where((element) =>
                                          element.weekday ==
                                          ApiConstants.shortThursday)
                                      .toList()),
                              ScheduleList(
                                  editMode: editMode,
                                  controller: scheduleListController,
                                  items: state.scheduleItems
                                      .where((element) =>
                                          element.weekday ==
                                          ApiConstants.shortFriday)
                                      .toList()),
                            ]),
                      ),
                    ],
                  );
                } else if (state is ScheduleItemErrorState) {
                  return Center(child: Text(state.message));
                } else if (state is ScheduleItemsEmptyState) {
                  return Center(
                    child: Text(
                      "Noch kein Stundenplan angelegt. Lege deinen ersten Stundenplan an, indem du auf das Plus-Symbol tippst!",
                      style: CupertinoTheme.of(context).textTheme.textStyle,
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  throw Exception("BLoC is in invalid state");
                }
              },
            ),
          ),
        ));
  }

  void scrollClickedPageIntoView(index) async {
    pageViewController.animateToPage(index,
        curve: Curves.ease, duration: Duration(milliseconds: 100));
  }

  void handleItemSelected(ScheduleItem item) {
    scheduleListController.selectedItems.add(item);
  }

  void handleItemDeselected(ScheduleItem item) {
    scheduleListController.selectedItems.remove(item);
  }

  void handleItemRemoved(ScheduleItem item) {
    scheduleItemBloc.add(FetchScheduleItemsFromLocalStorageEvent());
  }

  void handleAddOfficialPageResult(SelectedCourseInfo result) {
    if (result != null) {
      setState(() {
        editMode = true;
      });
      scheduleItemBloc.add(
          FetchScheduleItemsFromServerEvent(result.shortName, result.semester));
    }
  }

  void handlePageChanged(int value) async {
    controllerPageNotifier.value = value;

    // For some reason we need this delay or it will scroll to the wrong position
    await Future.delayed(Duration(milliseconds: 1));
    itemScrollController.scrollTo(
        index: value, duration: Duration(milliseconds: 50));
  }

  Widget buildNavigationBar() {
    return CupertinoNavigationBar(
      backgroundColor: CupertinoTheme.of(context).primaryContrastingColor,
      transitionBetweenRoutes: false,
      middle: Text("Stundenplan",
          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
      trailing: editMode
          ? CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(CupertinoIcons.check_mark,
                  color: CupertinoTheme.of(context)
                      .textTheme
                      .navTitleTextStyle
                      .color),
              onPressed: () {
                setState(() {
                  editMode = false;
                });
                var itemsMap = Map.fromIterable(
                    scheduleListController.selectedItems.map((e) => e.toJson()),
                    key: (item) =>
                        ScheduleItem.fromJson(item).hashCode.toString(),
                    value: (item) => item);
                JsonStore().setItem("schedule_items", itemsMap);
                scheduleItemBloc.add(FetchScheduleItemsFromLocalStorageEvent());
                scheduleListController.selectedItems.clear();
              })
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(
                  onPressed: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (builder) => CupertinoActionSheet(
                              actions: [
                                CupertinoActionSheetAction(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.of(context)
                                          .push<SelectedCourseInfo>(CupertinoPageRoute(
                                              builder: (context) => BlocProvider(
                                                  create: (BuildContext
                                                          context) =>
                                                      CourseInfoBloc(
                                                          repository:
                                                              CourseInfoRepository()),
                                                  child:
                                                      AddOfficialSchedulePage())))
                                          .then(handleAddOfficialPageResult);
                                    },
                                    child: Text("Offizieller Stundenplan")),
                                CupertinoActionSheetAction(
                                    onPressed: () {},
                                    child: Text("Eigener Eintrag")),
                              ],
                            ));
                  },
                  child: Icon(CupertinoIcons.add,
                      color: CupertinoTheme.of(context)
                          .textTheme
                          .navTitleTextStyle
                          .color),
                  padding: EdgeInsets.zero,
                ),
                CupertinoButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(CupertinoPageRoute(
                            builder: (context) => BlocProvider(
                                create: (BuildContext context) =>
                                    CourseInfoBloc(
                                        repository: CourseInfoRepository()),
                                child: ScheduleSettingsPage())))
                        .then((_) => {
                              scheduleItemBloc.add(
                                  FetchScheduleItemsFromLocalStorageEvent())
                            });
                  },
                  child: Icon(CupertinoIcons.ellipsis_vertical,
                      color: CupertinoTheme.of(context)
                          .textTheme
                          .navTitleTextStyle
                          .color),
                  padding: EdgeInsets.zero,
                )
              ],
            ),
    );
  }
}
