import 'package:fb4_app/areas/schedule/models/course_info.dart';
import 'package:fb4_app/areas/schedule/models/selected_course_info.dart';
import 'package:fb4_app/areas/schedule/viewmodels/add_official_schedule_page_viewmodel.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:fb4_app/core/views/base_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddOfficialSchedulePage extends StatelessWidget {
  final TextStyle dialogOptionStyle =
      const TextStyle(fontSize: 18, fontWeight: FontWeight.w400);

  void showModalForSelection<T>(
    BuildContext context,
    String title,
    List<T> items,
    List<String> itemDisplays,
    Function(T) onSelect,
  ) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CupertinoPopupSurface(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: CupertinoTheme.of(context).primaryContrastingColor,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 600,
                maxWidth: MediaQuery.of(context).size.width - 80,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.only(top: 12.0),
                        itemCount: itemDisplays.length,
                        separatorBuilder: (context, index) => const Divider(
                          color: CupertinoColors.systemGrey,
                          height: 1,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => onSelect(items[index]),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Text(itemDisplays[index]),
                            ),
                          );
                        },
                      ),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Abbrechen",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AddOfficialSchedulePageViewModel>(
      onViewModelCreated: (viewModel) => viewModel.init(),
      builder: (context, viewModel, child) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: ColorConsts.mainOrange,
          leading: Padding(
            padding: const EdgeInsets.only(top: 14.0),
            child: GestureDetector(
              onTap: Navigator.of(context).pop,
              child: const Text(
                "Abbrechen",
                style: TextStyle(
                  color: CupertinoColors.white,
                ),
              ),
            ),
          ),
          middle: Text(
            "Hinzufügen",
            style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
          ),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              if (viewModel.selectedCourse == null ||
                  viewModel.selectedSemester == "") {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text("Fehler"),
                    content: const Text(
                      "Es wurden nicht alle erforderlichen Felder ausgefüllt.",
                    ),
                    actions: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "Schließen",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                Navigator.of(context).pop(
                  SelectedCourseInfo(
                    viewModel.selectedCourse!.shortName,
                    viewModel.selectedSemester,
                    groupString: viewModel.selectedGroup,
                  ),
                );
              }
            },
            child: const Text(
              "Speichern",
              style: TextStyle(
                color: CupertinoColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Builder(
              builder: (context) {
                if (viewModel.courses.isNotEmpty) {
                  return Column(
                    children: [
                      CupertinoFormSection(
                        backgroundColor:
                            CupertinoColors.tertiarySystemBackground,
                        header: const Text('Erforderlich'),
                        children: [
                          CupertinoTextFormFieldRow(
                            prefix: const Padding(
                              padding: EdgeInsets.only(right: 50.0),
                              child: Text(
                                'Studiengang',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            placeholder: 'Wählen',
                            onTap: () {
                              viewModel.selectedSemester = "";
                              showModalForSelection<CourseInfo>(
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
                            prefix: const Text(
                              'Semester',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            placeholder: 'Wählen',
                            onTap: () {
                              if (viewModel.selectedCourse != null) {
                                showModalForSelection(
                                    context,
                                    "Semester wählen",
                                    viewModel.selectedCourse!.grades,
                                    viewModel.selectedCourse!.grades,
                                    (semester) {
                                  viewModel.selectedSemester =
                                      semester.toString();
                                  Navigator.of(context).pop();
                                });
                              } else {
                                showCupertinoDialog(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                    title: const Text("Fehler"),
                                    content: const Text(
                                      "Bitte wähle zuerst einen Studiengang aus.",
                                    ),
                                    actions: [
                                      GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: const Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Text(
                                            "Schließen",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }
                            },
                            textAlign: TextAlign.end,
                            readOnly: true,
                            controller: viewModel.semesterController,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: CupertinoFormSection(
                          backgroundColor:
                              CupertinoColors.tertiarySystemBackground,
                          header: const Text('Optional'),
                          children: [
                            CupertinoTextFormFieldRow(
                              prefix: const Text(
                                'Gruppenkennung',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              placeholder: 'Beispiel: C8',
                              textAlign: TextAlign.end,
                              controller: viewModel.groupController,
                              textCapitalization: TextCapitalization.characters,
                              validator: (input) {
                                if (input == "" ||
                                    RegExp('^[A-Z][0-9]+\$').hasMatch(input!)) {
                                  return null;
                                }
                                return "Muss folgendes beeinhalten:\n- Genau einen Buchstaben \n- Mindestens eine Zahl";
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                } else {
                  return const Center(child: CupertinoActivityIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
