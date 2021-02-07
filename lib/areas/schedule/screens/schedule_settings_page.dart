import 'package:fb4_app/areas/schedule/bloc/course_info_bloc.dart';
import 'package:fb4_app/areas/schedule/models/schedule_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
import 'package:json_store/json_store.dart';

class ScheduleSettingsPage extends StatefulWidget {
  final ScheduleSettings settings;
  ScheduleSettingsPage({Key key, this.settings}) : super(key: key);

  @override
  _ScheduleSettingsPageState createState() => _ScheduleSettingsPageState();
}

class _ScheduleSettingsPageState extends State<ScheduleSettingsPage> {
  CourseInfoBloc courseItemBloc;
  ScheduleSettings settings = ScheduleSettings();

  @override
  void initState() {
    super.initState();
    courseItemBloc = BlocProvider.of(context);
    courseItemBloc.add(FetchCourseInfoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          heroTag: 'scheduleSettingsPageNavBar',
          transitionBetweenRoutes: false,
          actionsForegroundColor: CupertinoColors.white,
          middle: Text("Einstellungen",
              style: TextStyle(color: CupertinoColors.white)),
          backgroundColor: CupertinoTheme.of(context).primaryColor,
        ),
        child: BlocBuilder<CourseInfoBloc, CourseInfoState>(
            builder: (builder, state) {
          if (state is CourseInfoInitial || state is CourseInfoLoading) {
            return Center(child: CupertinoActivityIndicator());
          } else if (state is CourseInfoLoaded) {
            return CupertinoSettings(items: <Widget>[
              CSButton(CSButtonType.DESTRUCTIVE, "Alle Einträge löschen", () {
                JsonStore().deleteItem("schedule_items");
              })
            ]);
          } else if (state is CourseInfoError) {
            return Center(child: Text(state.message));
          } else {
            throw Exception("BLoC is in invalid state.");
          }
        }));
  }
}
