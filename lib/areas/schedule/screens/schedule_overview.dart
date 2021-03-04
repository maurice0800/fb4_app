import 'package:fb4_app/areas/schedule/models/schedule_list_controller.dart';
import 'package:fb4_app/areas/schedule/models/selected_course_info.dart';
import 'package:fb4_app/areas/schedule/screens/add_official_schedule_page.dart';
import 'package:fb4_app/areas/schedule/screens/schedule_settings_page.dart';
import 'package:fb4_app/areas/schedule/viewmodels/add_official_schedule_page_viewmodel.dart';
import 'package:fb4_app/areas/schedule/viewmodels/schedule_overview_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: buildNavigationBar(),
        child: SafeArea(child: Container(child:
            Consumer<ScheduleOverviewViewModel>(
                builder: (context, viewModel, child) {
          if (viewModel.scheduleDays.length == 5) {
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
                                  color: index == controllerPageNotifier.value
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
                        viewModel.scheduleDays[0],
                        viewModel.scheduleDays[1],
                        viewModel.scheduleDays[2],
                        viewModel.scheduleDays[3],
                        viewModel.scheduleDays[4],
                      ]),
                ),
              ],
            );
          } else if (viewModel.isLoading) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          } else {
            print("Missing state");
            return Container();
          }
          //   } else if (state is ScheduleItemErrorState) {
          //     return Center(child: Text(state.message));
          //   } else if (state is ScheduleItemsEmptyState) {
          //     return Center(
          //       child: Text(
          //         "Noch kein Stundenplan angelegt. Lege deinen ersten Stundenplan an, indem du auf das Plus-Symbol tippst!",
          //         style: CupertinoTheme.of(context).textTheme.textStyle,
          //         textAlign: TextAlign.center,
          //       ),
          //     );
          //   } else {
          //     throw Exception("BLoC is in invalid state");
          //   }
          // },
        }))));
  }

  void scrollClickedPageIntoView(index) async {
    pageViewController.animateToPage(index,
        curve: Curves.ease, duration: Duration(milliseconds: 100));
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
        trailing: Consumer<ScheduleOverviewViewModel>(
            builder: (context, viewModel, child) {
          return viewModel.editMode
              ? CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(CupertinoIcons.check_mark,
                      color: CupertinoTheme.of(context)
                          .textTheme
                          .navTitleTextStyle
                          .color),
                  onPressed: () => viewModel.saveSelectedItemsToCache())
              : Row(mainAxisSize: MainAxisSize.min, children: [
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
                                            .push<SelectedCourseInfo>(
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        ChangeNotifierProvider(
                                                          create: (context) =>
                                                              AddOfficialSchedulePageViewModel()
                                                                ..init(),
                                                          child:
                                                              AddOfficialSchedulePage(),
                                                        )))
                                            .then((SelectedCourseInfo result) =>
                                                Provider.of<ScheduleOverviewViewModel>(
                                                        context,
                                                        listen: false)
                                                    .getScheduleListsFromServer(
                                                        result));
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
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => ScheduleSettingsPage()));
                      },
                      child: Icon(CupertinoIcons.ellipsis_vertical,
                          color: CupertinoTheme.of(context)
                              .textTheme
                              .navTitleTextStyle
                              .color),
                      padding: EdgeInsets.zero)
                ]);
        }));
  }
}
