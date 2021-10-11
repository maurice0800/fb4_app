import 'package:fb4_app/areas/schedule/models/schedule_item.dart';
import 'package:fb4_app/areas/schedule/models/selected_course_info.dart';
import 'package:fb4_app/areas/schedule/screens/add_custom_schedule_item_page.dart';
import 'package:fb4_app/areas/schedule/screens/add_official_schedule_page.dart';
import 'package:fb4_app/areas/schedule/viewmodels/schedule_overview_viewmodel.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:fb4_app/core/views/base_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ScheduleOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<ScheduleOverviewViewModel>(
        builder: (context, viewModel, child) => CupertinoScaffold(
              body: CupertinoPageScaffold(
                  navigationBar: buildNavigationBar(context, viewModel),
                  child: SafeArea(child: Builder(builder: (context) {
                    if (viewModel.hasItems) {
                      WidgetsBinding.instance?.addPostFrameCallback((_) async {
                        if (viewModel.aferNextRender != null) {
                          viewModel.aferNextRender();
                        }
                        viewModel.aferNextRender = () {};
                      });
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: ColorConsts.mainOrange,
                                border: Border(
                                    bottom: BorderSide(
                                        color: CupertinoTheme.brightnessOf(
                                                    context) ==
                                                Brightness.light
                                            ? CupertinoColors.systemGrey5
                                            : ColorConsts.mainOrange))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Expanded(
                                  child: ValueListenableBuilder<int>(
                                    valueListenable:
                                        viewModel.controllerPageNotifier,
                                    builder: (BuildContext context, value,
                                        Widget? child) {
                                      return CupertinoSegmentedControl(
                                          groupValue: value,
                                          pressedColor: ColorConsts.mainOrange,
                                          borderColor: CupertinoColors.white,
                                          unselectedColor:
                                              ColorConsts.mainOrange,
                                          selectedColor: CupertinoColors.white,
                                          children: const <int, Widget>{
                                            0: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Mo')),
                                            1: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Di')),
                                            2: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Mi')),
                                            3: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Do')),
                                            4: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Fr')),
                                          },
                                          onValueChanged: (val) {
                                            viewModel.controllerPageNotifier
                                                    .value =
                                                int.parse(val.toString());
                                            scrollClickedPageIntoView(
                                                viewModel.controllerPageNotifier
                                                    .value,
                                                viewModel.pageViewController);
                                          });
                                    },
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: PageView(
                                  controller: viewModel.pageViewController,
                                  onPageChanged: (index) => viewModel
                                      .controllerPageNotifier.value = index,
                                  children: <Widget>[
                                    viewModel.displayScheduleItems[0],
                                    viewModel.displayScheduleItems[1],
                                    viewModel.displayScheduleItems[2],
                                    viewModel.displayScheduleItems[3],
                                    viewModel.displayScheduleItems[4],
                                  ]),
                            ),
                          ),
                        ],
                      );
                    } else if (viewModel.isLoading) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    } else {
                      return Center(
                          child: Text(
                        "Noch kein Stundenplan angelegt. Lege deinen ersten Stundenplan an, indem du auf das Plus-Symbol tippst!",
                        style: CupertinoTheme.of(context).textTheme.textStyle,
                        textAlign: TextAlign.center,
                      ));
                    }
                  }))),
            ));
  }

  Future scrollClickedPageIntoView(int index, PageController controller) async {
    controller.animateToPage(index,
        curve: Curves.ease, duration: const Duration(milliseconds: 100));
  }

  ObstructingPreferredSizeWidget buildNavigationBar(
      BuildContext context, ScheduleOverviewViewModel viewModel) {
    return CupertinoNavigationBar(
        border: null,
        backgroundColor: ColorConsts.mainOrange,
        transitionBetweenRoutes: false,
        leading: Builder(builder: (context) {
          return viewModel.editMode
              ? CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(CupertinoIcons.xmark,
                      color: CupertinoTheme.of(context)
                          .textTheme
                          .navTitleTextStyle
                          .color),
                  onPressed: () {
                    viewModel.editMode = false;
                    viewModel.getScheduleListsFromDatabase();
                  })
              : Container();
        }),
        middle: Text("Stundenplan",
            style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
        trailing: Builder(builder: (context) {
          return viewModel.editMode
              ? CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(CupertinoIcons.check_mark,
                      color: CupertinoTheme.of(context)
                          .textTheme
                          .navTitleTextStyle
                          .color),
                  onPressed: () => viewModel.addSelectedItemsToList())
              : Row(mainAxisSize: MainAxisSize.min, children: [
                  CupertinoButton(
                    onPressed: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (builder) => CupertinoActionSheet(
                                actions: [
                                  CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        CupertinoScaffold
                                                .showCupertinoModalBottomSheet(
                                                    expand: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    context: context,
                                                    builder: (context) =>
                                                        AddOfficialSchedulePage())
                                            .then((result) {
                                          if (result != null) {
                                            viewModel
                                                .getScheduleListsFromServer(
                                                    result
                                                        as SelectedCourseInfo);
                                          }
                                        });
                                      },
                                      child: const Text(
                                          "Offizieller Stundenplan")),
                                  CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        CupertinoScaffold
                                                .showCupertinoModalBottomSheet(
                                                    context: context,
                                                    builder: (context) =>
                                                        const AddCustomScheduleItemPage())
                                            .then((result) => {
                                                  if (result != null)
                                                    {
                                                      viewModel.addCustomItem(
                                                          result
                                                              as ScheduleItem)
                                                    }
                                                });
                                      },
                                      child: const Text("Eigener Eintrag")),
                                ],
                              ));
                    },
                    padding: EdgeInsets.zero,
                    child: Icon(CupertinoIcons.add,
                        color: CupertinoTheme.of(context)
                            .textTheme
                            .navTitleTextStyle
                            .color),
                  ),
                ]);
        }));
  }
}
