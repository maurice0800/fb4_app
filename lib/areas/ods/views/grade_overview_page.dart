import 'package:fb4_app/areas/ods/viewmodels/grades_overview_page_viewmodel.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:fb4_app/core/views/base_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_list_view/group_list_view.dart';

class GradeOverViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<GradeOverviewPageViewModel>(
      onViewModelCreated: (viewModel) => viewModel.getGradeList(),
      builder: (context, viewModel, child) => CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("Notenübersicht"),
          backgroundColor: ColorConsts.mainOrange,
        ),
        child: SafeArea(
          child: viewModel.exams.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    textStyle: TextStyle(
                      color:
                          CupertinoTheme.of(context).textTheme.textStyle.color,
                    ),
                    color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                    child: GroupListView(
                      countOfItemInSection: (section) =>
                          viewModel.exams[section + 1]?.length ?? 0,
                      sectionsCount: viewModel.exams.entries.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 5.0,
                      ),
                      groupHeaderBuilder: (context, section) => Padding(
                        padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
                        child: Text(
                          "${section + 1}. Semester",
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      itemBuilder: (context, index) => ExpansionTile(
                        backgroundColor:
                            CupertinoTheme.of(context).barBackgroundColor,
                        collapsedBackgroundColor:
                            CupertinoTheme.of(context).barBackgroundColor,
                        title: Text(
                          viewModel.exams[index.section + 1]![index.index].name,
                          style: TextStyle(
                            color: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .color,
                          ),
                        ),
                        trailing: Text(
                          viewModel.exams[index.section + 1]![index.index]
                                      .grade !=
                                  ""
                              ? viewModel
                                  .exams[index.section + 1]![index.index].grade
                                  .padRight(2, ",0")
                              : "-",
                          style: TextStyle(
                            color: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .color,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Prüfungsart: ${viewModel.exams[index.section + 1]![index.index].examKind}",
                                ),
                                Text(
                                  "Versuch: ${viewModel.exams[index.section + 1]![index.index].tryCount}",
                                ),
                                Text(
                                  "ECTS: ${viewModel.exams[index.section + 1]![index.index].ects}",
                                ),
                                Text(
                                  "Status: ${viewModel.exams[index.section + 1]![index.index].status}",
                                ),
                                Text(
                                  "Anmerkungen: ${viewModel.exams[index.section + 1]![index.index].additional}",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const Center(
                  child: CupertinoActivityIndicator(),
                ),
        ),
      ),
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Fehler"),
        content: Text(
          "Beim Abrufen der News ist ein Fehler aufgetreten:\n$message",
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
}
