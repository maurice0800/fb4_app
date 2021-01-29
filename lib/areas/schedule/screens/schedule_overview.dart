import 'package:fb4_app/api_constants.dart';
import 'package:fb4_app/areas/schedule/bloc/course_info_bloc.dart';
import 'package:fb4_app/areas/schedule/bloc/schedule_item_bloc.dart';
import 'package:fb4_app/areas/schedule/bloc/schedule_item_event.dart';
import 'package:fb4_app/areas/schedule/bloc/schedule_item_state.dart';
import 'package:fb4_app/areas/schedule/models/schedule_settings.dart';
import 'package:fb4_app/areas/schedule/repositories/course_info_repository.dart';
import 'package:fb4_app/areas/schedule/screens/schedule_settings_page.dart';
import 'package:fb4_app/areas/schedule/widgets/schedule_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleOverview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScheduleOverviewState();
  }
}

class ScheduleOverviewState extends State<ScheduleOverview> {
  final PageController controller = PageController();

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
          backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
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
                    Icon(CupertinoIcons.settings, color: CupertinoColors.black),
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
                return PageView(controller: controller, children: <Widget>[
                  ScheduleList(
                      weekday: "Montag",
                      items: state.scheduleItems
                          .where((element) =>
                              element.weekday == ApiConstants.shortMonday)
                          .toList()),
                  ScheduleList(
                      weekday: "Dienstag",
                      items: state.scheduleItems
                          .where((element) =>
                              element.weekday == ApiConstants.shortTuesday)
                          .toList()),
                  ScheduleList(
                      weekday: "Mittwoch",
                      items: state.scheduleItems
                          .where((element) =>
                              element.weekday == ApiConstants.shortWednesday)
                          .toList()),
                  ScheduleList(
                      weekday: "Donnerstag",
                      items: state.scheduleItems
                          .where((element) =>
                              element.weekday == ApiConstants.shortThursday)
                          .toList()),
                  ScheduleList(
                      weekday: "Freitag",
                      items: state.scheduleItems
                          .where((element) =>
                              element.weekday == ApiConstants.shortFriday)
                          .toList()),
                ]);
              } else if (state is ScheduleItemErrorState) {
                return Center(child: Text(state.message));
              } else {
                return Container();
              }
            },
          ),
        ))));
  }
}
