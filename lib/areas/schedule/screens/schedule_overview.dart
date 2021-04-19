import 'package:fb4_app/app_constants.dart';
import 'package:fb4_app/areas/schedule/screens/add_custom_schedule_item_page.dart';
import 'package:fb4_app/areas/schedule/screens/add_official_schedule_page.dart';
import 'package:fb4_app/areas/schedule/viewmodels/schedule_overview_viewmodel.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class ScheduleOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: buildNavigationBar(context),
        child: SafeArea(child: Container(child:
            Consumer<ScheduleOverviewViewModel>(
                builder: (context, viewModel, child) {
          if (viewModel.hasItems) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (viewModel.aferNextRender != null) {
                viewModel.aferNextRender();
                viewModel.aferNextRender = null;
              }
            });
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: ColorConsts.mainOrange,
                      border: Border(
                          bottom: BorderSide(
                              width: 1.0,
                              color: CupertinoTheme.brightnessOf(context) ==
                                      Brightness.light
                                  ? CupertinoColors.systemGrey5
                                  : ColorConsts.mainOrange))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      Expanded(
                        child: ValueListenableBuilder<int>(
                          valueListenable: viewModel.controllerPageNotifier,
                          builder: (BuildContext context, value, Widget child) {
                            return CupertinoSegmentedControl(
                                groupValue: value,
                                pressedColor: ColorConsts.mainOrange,
                                borderColor: CupertinoColors.white,
                                unselectedColor: ColorConsts.mainOrange,
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
                                  viewModel.controllerPageNotifier.value = val;
                                  scrollClickedPageIntoView(
                                      val, viewModel.pageViewController);
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
                        onPageChanged: (index) =>
                            viewModel.controllerPageNotifier.value = index,
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
            return Center(
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
        }))));
  }

  void scrollClickedPageIntoView(index, controller) async {
    controller.animateToPage(index,
        curve: Curves.ease, duration: Duration(milliseconds: 100));
  }

  void handlePageChanged(int value) async {
    // controllerPageNotifier.value = value;
  }

  Widget buildNavigationBar(BuildContext context) {
    return CupertinoNavigationBar(
        border: null,
        backgroundColor: ColorConsts.mainOrange,
        transitionBetweenRoutes: false,
        leading: Consumer<ScheduleOverviewViewModel>(
            builder: (context, viewModel, child) {
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
        trailing: Consumer<ScheduleOverviewViewModel>(
            builder: (context, viewModel, child) {
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
                                        showCupertinoModalBottomSheet(
                                                context: context,
                                                builder: (context) =>
                                                    AddOfficialSchedulePage())
                                            .then((result) {
                                          viewModel.getScheduleListsFromServer(
                                              result);
                                        });
                                      },
                                      child: Text("Offizieller Stundenplan")),
                                  CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showCupertinoModalBottomSheet(
                                                context: context,
                                                builder: (context) =>
                                                    AddCustomScheduleItemPage())
                                            .then((result) => viewModel
                                                .addCustomItem(result));
                                      },
                                      child: Text("Eigener Eintrag")),
                                ],
                              ));
                    },
                    child: Icon(CupertinoIcons.add,
                        color: CupertinoTheme.of(context)
                            .textTheme
                            .navTitleTextStyle
                            .color),
                    padding: EdgeInsets.zero,
                  ),
                ]);
        }));
  }
}
