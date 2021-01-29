import 'package:fb4_app/areas/schedule/bloc/course_info_bloc.dart';
import 'package:fb4_app/areas/schedule/models/schedule_settings.dart';
import 'package:fb4_app/areas/schedule/repositories/course_info_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';

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
          actionsForegroundColor: CupertinoColors.white,
          middle: Text("Einstellungen",
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
          backgroundColor: CupertinoTheme.of(context).primaryColor,
        ),
        child: BlocBuilder<CourseInfoBloc, CourseInfoState>(
            builder: (builder, state) {
          if (state is CourseInfoInitial || state is CourseInfoLoading) {
            return Center(child: CupertinoActivityIndicator());
          } else if (state is CourseInfoLoaded) {
            return CupertinoSettings(items: <Widget>[
              CSControl(
                nameWidget: Text("Studiengang"),
                contentWidget: Text("Duali"),
              )
            ]);
          } else if (state is CourseInfoError) {
            return Center(child: Text(state.message));
          }
        }));
  }
}
