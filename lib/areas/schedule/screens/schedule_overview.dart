import 'package:fb4_app/api_constants.dart';
import 'package:fb4_app/areas/schedule/bloc/course_info_bloc.dart';
import 'package:fb4_app/areas/schedule/bloc/schedule_item_bloc.dart';
import 'package:fb4_app/areas/schedule/bloc/schedule_item_event.dart';
import 'package:fb4_app/areas/schedule/bloc/schedule_item_state.dart';
import 'package:fb4_app/areas/schedule/repositories/course_info_repository.dart';
import 'package:fb4_app/areas/schedule/screens/schedule_settings_page.dart';
import 'package:fb4_app/areas/schedule/widgets/schedule_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ScheduleOverview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScheduleOverviewState();
  }
}

class ScheduleOverviewState extends State<ScheduleOverview> {
  ScrollDirection currentScrollDirection;
  final PageController pageViewController = PageController();
  final ItemScrollController itemScrollController = ItemScrollController();
  ValueNotifier controllerPageNotifier = ValueNotifier(0);
  final List<String> weekdays = [
    "Montag",
    "Dienstag",
    "Mittwoch",
    "Donnerstag",
    "Freitag",

    // This is not fancy, but the scrollview is behaving weirdly when the end of list is visible while scrolling
    "                                                                       ",
  ];

  ScheduleItemBloc scheduleItemBloc;

  @override
  void initState() {
    super.initState();

    scheduleItemBloc = BlocProvider.of<ScheduleItemBloc>(context);
    scheduleItemBloc.add(FetchScheduleItemsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.activeOrange,
          transitionBetweenRoutes: false,
          middle: Text("Stundenplan",
              style: CupertinoTheme.of(context).textTheme.textStyle),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoButton(
                onPressed: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (context) => CupertinoActionSheet(
                            actions: [
                              CupertinoActionSheetAction(
                                  onPressed: () {},
                                  child: Text("Offizieller Stundenplan")),
                              CupertinoActionSheetAction(
                                  onPressed: () {},
                                  child: Text("Eigener Eintrag")),
                            ],
                          ));
                },
                child: Icon(CupertinoIcons.add, color: CupertinoColors.white),
                padding: EdgeInsets.zero,
              ),
              CupertinoButton(
                onPressed: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => BlocProvider(
                          create: (BuildContext context) => CourseInfoBloc(
                              repository: CourseInfoRepository()),
                          child: ScheduleSettingsPage())));
                },
                child:
                    Icon(CupertinoIcons.settings, color: CupertinoColors.white),
                padding: EdgeInsets.zero,
              )
            ],
          ),
        ),
        child: Container(
            child: BlocListener<ScheduleItemBloc, ScheduleItemState>(
                listener: (context, state) {
          if (state is ScheduleItemErrorState) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
          }
        }, child: SafeArea(
          child: BlocBuilder<ScheduleItemBloc, ScheduleItemState>(
            builder: (context, state) {
              if (state is ScheduleItemLoadingState ||
                  state is ScheduleItemInitialState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ScheduleItemLoadedState) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  pageViewController.position.addListener(() {
                    scrollDirectionListener();
                  });
                });
                return Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ValueListenableBuilder(
                        valueListenable: controllerPageNotifier,
                        builder: (context, value, _) =>
                            ScrollablePositionedList.separated(
                          itemCount: weekdays.length,
                          itemScrollController: itemScrollController,
                          separatorBuilder: (context, index) => SizedBox(),
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 8.0, right: 10.0),
                            child: GestureDetector(
                              onTap: () => scrollClickedPageIntoView(index),
                              child: Text(weekdays[index],
                                  style: TextStyle(
                                      color:
                                          index == controllerPageNotifier.value
                                              ? CupertinoColors.black
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
                      flex: 18,
                      child: PageView(
                          controller: pageViewController,
                          children: <Widget>[
                            ScheduleList(
                                items: state.scheduleItems
                                    .where((element) =>
                                        element.weekday ==
                                        ApiConstants.shortMonday)
                                    .toList()),
                            ScheduleList(
                                items: state.scheduleItems
                                    .where((element) =>
                                        element.weekday ==
                                        ApiConstants.shortTuesday)
                                    .toList()),
                            ScheduleList(
                                items: state.scheduleItems
                                    .where((element) =>
                                        element.weekday ==
                                        ApiConstants.shortWednesday)
                                    .toList()),
                            ScheduleList(
                                items: state.scheduleItems
                                    .where((element) =>
                                        element.weekday ==
                                        ApiConstants.shortThursday)
                                    .toList()),
                            ScheduleList(
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
              } else {
                return Container();
              }
            },
          ),
        ))));
  }

  // This is not fancy but the listener fires one time for every PIXEL the page is moving. So we somehow have to prevent multiple re-renders for the same swipe.
  void scrollDirectionListener() async {
    if (pageViewController.position.userScrollDirection !=
        currentScrollDirection) {
      currentScrollDirection = pageViewController.position.userScrollDirection;
      if (currentScrollDirection == ScrollDirection.reverse) {
        var newIndex = pageViewController.page.ceil();

        if (controllerPageNotifier.value != newIndex) {
          itemScrollController.scrollTo(
              index: newIndex, duration: Duration(milliseconds: 100));
        }

        controllerPageNotifier.value = newIndex;

        // Wait for scroll to finish
        await Future.delayed(Duration(milliseconds: 600));
        currentScrollDirection = null;
      } else {
        var newIndex = pageViewController.page.floor();

        if (controllerPageNotifier.value != newIndex) {
          itemScrollController.scrollTo(
              index: newIndex, duration: Duration(milliseconds: 100));
        }

        controllerPageNotifier.value = newIndex;

        // Wait for scroll to finish
        await Future.delayed(Duration(milliseconds: 600));
        currentScrollDirection = null;
      }
    }
  }

  void scrollClickedPageIntoView(index) {
    pageViewController.animateToPage(index,
        curve: Curves.ease, duration: Duration(milliseconds: 100));
    itemScrollController.scrollTo(
        index: index, duration: Duration(milliseconds: 100));
  }
}
