import 'package:fb4_app/areas/schedule/models/selected_course_info.dart';
import 'package:fb4_app/areas/schedule/viewmodels/add_official_schedule_page_viewmodel.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddOfficialSchedulePage extends StatelessWidget {
  final TextStyle dialogOptionStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w400);

  void showModalForSelection<T>(BuildContext context, String title,
      List<T> items, List<String> itemDisplays, Function(T) onSelect) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CupertinoPopupSurface(
          child: Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: CupertinoTheme.of(context).primaryContrastingColor),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Divider(),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 12.0),
                      itemCount: itemDisplays.length,
                      separatorBuilder: (context, index) => Divider(
                        color: CupertinoColors.systemGrey,
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onSelect(items[index]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Text(itemDisplays[index]),
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
    return ChangeNotifierProvider<AddOfficialSchedulePageViewModel>(
        create: (context) => AddOfficialSchedulePageViewModel()..init(),
        child: Consumer<AddOfficialSchedulePageViewModel>(
            builder: (context, viewModel, child) {
          return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                  backgroundColor: ColorConsts.mainOrange,
                  middle: Text("Hinzufügen",
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .navTitleTextStyle),
                  trailing: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (viewModel.selectedCourse == null ||
                            viewModel.selectedSemester == "") {
                          showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                    title: Text("Fehler"),
                                    content: Text(
                                        "Es wurden nicht alle erforderlichen Felder ausgefüllt."),
                                    actions: [
                                      GestureDetector(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            "Schließen",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        onTap: () => Navigator.pop(context),
                                      )
                                    ],
                                  ));
                        } else {
                          Navigator.of(context).pop(SelectedCourseInfo(
                              viewModel.selectedCourse.shortName,
                              viewModel.selectedSemester,
                              groupString: viewModel.selectedGroup));
                        }
                      },
                      child: Text("Spiechern",
                          style: TextStyle(color: CupertinoColors.white)))),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Builder(builder: (context) {
                    if (viewModel.courses.length > 0) {
                      return Column(children: [
                        CupertinoFormSection(
                            backgroundColor:
                                CupertinoColors.tertiarySystemBackground,
                            header: Text('Erforderlich'),
                            children: [
                              CupertinoTextFormFieldRow(
                                prefix: Padding(
                                  padding: const EdgeInsets.only(right: 50.0),
                                  child: Text('Studiengang'),
                                ),
                                placeholder: 'Wählen',
                                onTap: () {
                                  viewModel.selectedSemester = "";
                                  showModalForSelection(
                                      context,
                                      "Studiengang wählen",
                                      viewModel.courses,
                                      viewModel.courses
                                          .map((course) => course.name)
                                          .toList(), (course) {
                                    viewModel.selectedCourse = course;
                                    Navigator.of(context).pop();
                                  });
                                },
                                textAlign: TextAlign.end,
                                readOnly: true,
                                controller: viewModel.courseController,
                              ),
                              CupertinoTextFormFieldRow(
                                prefix: Text('Semester'),
                                placeholder: 'Wählen',
                                onTap: () {
                                  if (viewModel.selectedCourse != null) {
                                    showModalForSelection(
                                        context,
                                        "Semester wählen",
                                        viewModel.selectedCourse.grades,
                                        viewModel.selectedCourse.grades,
                                        (semester) {
                                      viewModel.selectedSemester = semester;
                                      Navigator.of(context).pop();
                                    });
                                  } else {
                                    showCupertinoDialog(
                                        context: context,
                                        builder: (context) =>
                                            CupertinoAlertDialog(
                                              title: Text("Fehler"),
                                              content: Text(
                                                  "Bitte wähle zuerst einen Studiengang aus."),
                                              actions: [
                                                GestureDetector(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Text(
                                                      "Schließen",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  onTap: () =>
                                                      Navigator.pop(context),
                                                )
                                              ],
                                            ));
                                  }
                                },
                                textAlign: TextAlign.end,
                                readOnly: true,
                                controller: viewModel.semesterController,
                              ),
                            ]),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: CupertinoFormSection(
                              backgroundColor:
                                  CupertinoColors.tertiarySystemBackground,
                              header: Text('Optional'),
                              children: [
                                CupertinoTextFormFieldRow(
                                  prefix: Text('Gruppenkennung'),
                                  placeholder: 'Beispiel: C8',
                                  textAlign: TextAlign.end,
                                  controller: viewModel.groupController,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  validator: (input) {
                                    if (input == "" ||
                                        RegExp('^[A-Z][0-9]+\$')
                                            .hasMatch(input)) {
                                      return null;
                                    }
                                    return "Muss folgendes beeinhalten:\n- Genau einen Buchstaben \n- Mindestens eine Zahl";
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                ),
                              ]),
                        )
                      ]);
                    } else {
                      return Center(child: CupertinoActivityIndicator());
                    }
                  }),
                ),
              ));
        }));
  }
}
