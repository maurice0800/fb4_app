import 'package:fb4_app/areas/schedule/bloc/course_info_bloc.dart';
import 'package:fb4_app/areas/schedule/models/course_info.dart';
import 'package:fb4_app/areas/schedule/models/selected_course_info.dart';
import 'package:fb4_app/utils/helpers/alphabet_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';

class AddOfficialSchedulePage extends StatefulWidget {
  AddOfficialSchedulePage({Key key}) : super(key: key);

  @override
  _AddOfficialSchedulePageState createState() =>
      _AddOfficialSchedulePageState();
}

class _AddOfficialSchedulePageState extends State<AddOfficialSchedulePage> {
  CourseInfoBloc courseInfoBloc;

  CourseInfo selectedCourse;
  String selectedGroup;
  String selectedSemester = "";

  @override
  void initState() {
    super.initState();
    courseInfoBloc = BlocProvider.of<CourseInfoBloc>(context);
    courseInfoBloc.add(FetchCourseInfoEvent());
  }

  TextStyle dialogOptionStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w400);

  void showModalForSelection<T>(String title, List<T> items,
      List<String> itemDisplays, Function(T) onSelect) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CupertinoPopupSurface(
          child: Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: CupertinoColors.white),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: 600,
                maxWidth: MediaQuery.of(context).size.width - 80),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black,
                          fontSize: 18)),
                  Divider(),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 12.0),
                      itemCount: itemDisplays.length,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => onSelect(items[index]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(itemDisplays[index],
                                style: TextStyle(color: CupertinoColors.black)),
                          ),
                        );
                      },
                    ),
                  ),
                  CupertinoButton(
                      child: Text(
                        "Abbrechen",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Stundenplan hinzufügen",
              style: TextStyle(color: CupertinoColors.white)),
          backgroundColor: CupertinoColors.activeOrange,
          trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pop(
                    context,
                    SelectedCourseInfo(
                        selectedCourse.shortName, selectedSemester));
              },
              child: Icon(CupertinoIcons.check_mark,
                  color: CupertinoColors.white)),
        ),
        child: BlocBuilder<CourseInfoBloc, CourseInfoState>(
            builder: (context, state) {
          if (state is CourseInfoInitial || state is CourseInfoLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CourseInfoLoaded) {
            return Column(children: [
              GestureDetector(
                onTap: () => showModalForSelection(
                    "Studiengang wählen",
                    state.courses,
                    state.courses.map((course) => course.name).toList(),
                    (course) {
                  setState(() {
                    selectedCourse = course;
                  });
                  Navigator.of(context).pop();
                }),
                child: Flexible(
                  child: CSControl(
                    nameWidget: Text("Studiengang"),
                    contentWidget: Padding(
                      padding: const EdgeInsets.only(left: 80.0),
                      child: Flexible(
                        child: Text(
                          selectedCourse != null
                              ? selectedCourse.name
                              : "Auswählen...",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => showModalForSelection("Semester wählen",
                    selectedCourse.grades, selectedCourse.grades, (semester) {
                  setState(() {
                    selectedSemester = semester;
                  });
                  Navigator.of(context).pop();
                }),
                child: CSControl(
                  nameWidget: Text("Semester"),
                  contentWidget: Text(selectedSemester.isNotEmpty
                      ? selectedSemester
                      : "Kein Kurs gewählt"),
                ),
              ),
              GestureDetector(
                onTap: () => showModalForSelection(
                    "Gruppenbuchstabe wählen",
                    AlphabetList.getAlphabet(),
                    AlphabetList.getAlphabet(),
                    (group) => {
                          setState(() {
                            selectedGroup = group;
                          }),
                          Navigator.pop(context)
                        }),
                child: CSControl(
                  nameWidget: Text("Gruppenbuchstabe"),
                  contentWidget: Text(
                      selectedGroup != null ? selectedGroup : "Auswählen..."),
                ),
              )
            ]);
          } else {
            throw Exception("BLoC is in invalid state.");
          }
        }));
  }
}
