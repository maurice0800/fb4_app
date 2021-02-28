import 'package:fb4_app/areas/schedule/models/selected_course_info.dart';
import 'package:fb4_app/areas/schedule/viewmodels/add_official_schedule_page_viewmodel.dart';
import 'package:fb4_app/utils/helpers/alphabet_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
import 'package:provider/provider.dart';

class AddOfficialSchedulePage extends StatefulWidget {
  AddOfficialSchedulePage({Key key}) : super(key: key);

  @override
  _AddOfficialSchedulePageState createState() =>
      _AddOfficialSchedulePageState();
}

class _AddOfficialSchedulePageState extends State<AddOfficialSchedulePage> {
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
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
          trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                var viewModel = Provider.of<AddOfficialSchedulePageViewModel>(
                    context,
                    listen: false);
                Navigator.of(context).pop(SelectedCourseInfo(
                    viewModel.selectedCourse.shortName,
                    viewModel.selectedSemester,
                    group: viewModel.selectedGroup));
              },
              child: Icon(CupertinoIcons.check_mark,
                  color: CupertinoTheme.of(context)
                      .textTheme
                      .navTitleTextStyle
                      .color)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Consumer<AddOfficialSchedulePageViewModel>(
                builder: (context, viewModel, child) {
              if (viewModel.courses.length > 0) {
                return Column(children: [
                  GestureDetector(
                    onTap: () => showModalForSelection(
                        "Studiengang wählen",
                        viewModel.courses,
                        viewModel.courses.map((course) => course.name).toList(),
                        (course) {
                      viewModel.selectedCourse = course;
                      Navigator.of(context).pop();
                    }),
                    child: CSControl(
                      nameWidget: Text("Studiengang"),
                      contentWidget: Padding(
                        padding: const EdgeInsets.only(left: 80.0),
                        child: Text(
                          viewModel.selectedCourse != null
                              ? viewModel.selectedCourse.name
                              : "Auswählen...",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => showModalForSelection(
                        "Semester wählen",
                        viewModel.selectedCourse.grades,
                        viewModel.selectedCourse.grades, (semester) {
                      setState(() {
                        viewModel.selectedSemester = semester;
                      });
                      Navigator.of(context).pop();
                    }),
                    child: CSControl(
                      nameWidget: Text("Semester"),
                      contentWidget: Text(viewModel.selectedSemester.isNotEmpty
                          ? viewModel.selectedSemester
                          : "Kein Kurs gewählt"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => showModalForSelection(
                        "Gruppenbuchstabe wählen",
                        AlphabetList.getAlphabet(),
                        AlphabetList.getAlphabet(),
                        (group) => {
                              viewModel.selectedGroup = group,
                              Navigator.pop(context)
                            }),
                    child: CSControl(
                      nameWidget: Text("Gruppenbuchstabe"),
                      contentWidget: Text(viewModel.selectedGroup != null
                          ? viewModel.selectedGroup
                          : "Auswählen..."),
                    ),
                  )
                ]);
              } else {
                return Center(child: CupertinoActivityIndicator());
              }
            }),
          ),
        ));
  }
}
