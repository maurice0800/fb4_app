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
          backgroundColor: ColorConsts.mainOrange,
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
                    groupString: viewModel.selectedGroup));
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
                  CupertinoFormSection(
                      backgroundColor: CupertinoColors.tertiarySystemBackground,
                      header: Text('Erforderlich'),
                      children: [
                        CupertinoTextFormFieldRow(
                          prefix: Padding(
                            padding: const EdgeInsets.only(right: 50.0),
                            child: Text('Studiengang'),
                          ),
                          placeholder: 'Wählen',
                          onTap: () => showModalForSelection(
                              context,
                              "Studiengang wählen",
                              viewModel.courses,
                              viewModel.courses
                                  .map((course) => course.name)
                                  .toList(), (course) {
                            viewModel.selectedCourse = course;
                            Navigator.of(context).pop();
                          }),
                          textAlign: TextAlign.end,
                          readOnly: true,
                          controller: viewModel.courseController,
                        ),
                        CupertinoTextFormFieldRow(
                          prefix: Text('Semester'),
                          placeholder: 'Wählen',
                          onTap: () => showModalForSelection(
                              context,
                              "Semester wählen",
                              viewModel.selectedCourse.grades,
                              viewModel.selectedCourse.grades, (semester) {
                            viewModel.selectedSemester = semester;
                            Navigator.of(context).pop();
                          }),
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
                            prefix: Text('Gruppenbuchstabe'),
                            placeholder: '*',
                            textAlign: TextAlign.end,
                            controller: viewModel.groupController,
                            textCapitalization: TextCapitalization.characters,
                            validator: (input) {
                              if (input == "" ||
                                  RegExp('^[A-Z][0-9]+\$').hasMatch(input)) {
                                return null;
                              }
                              return "Ungültiges Format!";
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
  }
}
