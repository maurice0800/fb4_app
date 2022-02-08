import 'package:fb4_app/areas/canteen/models/canteen.dart';
import 'package:fb4_app/areas/canteen/models/meal.dart';
import 'package:fb4_app/areas/canteen/viewmodels/canteen_overview_viewmodel.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:fb4_app/core/views/base_view.dart';
import 'package:fb4_app/utils/ui/icons/fb4app_icons.dart';
import 'package:fb4_app/utils/ui/widgets/cupertino_horizontal_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CanteenOverviewPage extends StatelessWidget {
  const CanteenOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoTheme.of(context).brightness == Brightness.light
          ? CupertinoColors.extraLightBackgroundGray
          : CupertinoColors.black,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: ColorConsts.mainOrange,
        middle: Text("Mensa"),
        border: null,
      ),
      child: BaseView<CanteenOverviewViewModel>(
        builder: (context, viewModel, child) => viewModel
                .enabledCanteens.isNotEmpty
            ? Column(children: [
                ValueListenableBuilder(
                  valueListenable: viewModel.currentDate,
                  builder: (context, DateTime value, _) =>
                      CupertinoHorizontalDatePicker(
                    onDateTimeChanged: viewModel.onSelectedDateChanged,
                    initialDate: value,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: PageView.builder(
                      itemCount: 14,
                      onPageChanged: viewModel.onPageSwiped,
                      controller: viewModel.pageController,
                      itemBuilder: (context, index) =>
                          FutureBuilder<Map<Canteen, List<Meal>>>(
                        future: viewModel.getMealsForCanteensAtDateIndex(index),
                        builder: (context, snapshot) => snapshot.hasData
                            ? ListView.builder(
                                itemCount: viewModel.enabledCanteens.length,
                                itemBuilder: (context, index) => Card(
                                    color: CupertinoTheme.of(context)
                                        .primaryContrastingColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: MealCardInner(
                                        canteenName: viewModel
                                            .enabledCanteens[index].name,
                                        meals: snapshot.data![viewModel
                                                .enabledCanteens[index]] ??
                                            [],
                                      ),
                                    )))
                            : const CupertinoActivityIndicator(),
                      ),
                    ),
                  ),
                ),
              ])
            : const Center(
                child: Text(
                "Noch keine Mensen ausgewählt!\nBitte gehe in die Einstellungen und wähle deine bevorzugten Mensen aus.",
                textAlign: TextAlign.center,
              )),
      ),
    );
  }
}

class MealCardInner extends StatelessWidget {
  final String canteenName;
  final List<Meal> meals;

  const MealCardInner({
    required this.canteenName,
    required this.meals,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            canteenName,
            style: CupertinoTheme.of(context)
                .textTheme
                .textStyle
                .merge(const TextStyle(fontSize: 22.0)),
          ),
          Divider(
              thickness: 2.0, color: CupertinoTheme.of(context).primaryColor),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 6.0),
            child: Center(
              child: Text("Keine Daten vorhanden",
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .merge(const TextStyle(fontSize: 20.0))),
            ),
          )
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(canteenName,
            style: CupertinoTheme.of(context)
                .textTheme
                .textStyle
                .merge(const TextStyle(fontSize: 22.0))),
        Divider(thickness: 2.0, color: CupertinoTheme.of(context).primaryColor),
        Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 6.0),
          child: Text("Hauptspeisen",
              style: CupertinoTheme.of(context)
                  .textTheme
                  .textStyle
                  .merge(const TextStyle(fontSize: 20.0))),
        ),
        CanteenMealsList(
            meals: meals.where((m) => m.type != "Beilagen").toList()),
        if (meals.where((m) => m.type == "Beilagen").isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                  thickness: 0.8,
                  color: CupertinoTheme.of(context).primaryColor),
              Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 6.0),
                  child: Text("Beilagen",
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .textStyle
                          .merge(const TextStyle(fontSize: 20.0)))),
              CanteenMealsList(
                  meals: meals.where((m) => m.type == "Beilagen").toList(),
                  shrink: true),
            ],
          )
      ],
    );
  }
}

class CanteenMealsList extends StatelessWidget {
  final List<Meal> meals;
  final bool? shrink;

  const CanteenMealsList({
    Key? key,
    required this.meals,
    this.shrink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: meals.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => showMealInfoModal(context, meals[index]),
        child: Column(
          children: [
            const Divider(thickness: 1.0, height: 4.0),
            MealItem(meal: meals[index], shrink: shrink),
          ],
        ),
      ),
    );
  }

  void showMealInfoModal(BuildContext context, Meal meal) {
    final numberFormat = NumberFormat.simpleCurrency(locale: "de_DE");

    showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Menüdetails"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              meal.title,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 12.0),
            const Text("Kategorie",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(meal.type),
            const SizedBox(height: 12.0),
            const Text("Preise", style: TextStyle(fontWeight: FontWeight.bold)),
            ...meal.prices.entries
                .where((entry) => entry.value != null)
                .map((entry) => Text(
                    "${getLocalizedPriceCategory(entry.key)}: ${numberFormat.format(entry.value)}"))
                .toList(),
            const SizedBox(height: 12.0),
            const Text("Anmerkungen",
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...meal.notes.map((m) => Text(m))
          ],
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text("Schließen"),
          )
        ],
      ),
    );
  }

  String getLocalizedPriceCategory(String s) {
    switch (s) {
      case "students":
        return "Studierende";
      case "employees":
        return "Mitarbeitende";
      case "pupils":
        return "Schüler";
      case "others":
        return "Andere";
      default:
        return "Unbekannte Kategorie";
    }
  }
}

class MealItem extends StatelessWidget {
  final Meal meal;
  final bool? shrink;

  const MealItem({
    Key? key,
    required this.meal,
    this.shrink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: (shrink ?? false)
          ? const EdgeInsets.symmetric(vertical: 4.0)
          : const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
              child: Text(meal.title,
                  style: CupertinoTheme.of(context).textTheme.textStyle)),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: MealInfoText(
              meal: meal,
            ),
          ),
        ],
      ),
    );
  }
}

class MealInfoText extends StatelessWidget {
  final Meal meal;
  const MealInfoText({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(
        getCategoryIcon(meal.type),
        color: CupertinoTheme.of(context).textTheme.textStyle.color,
      ),
    ]);
  }

  IconData? getCategoryIcon(String category) {
    switch (category) {
      case "Tagesgericht":
        return CupertinoIcons.calendar;
      case "Menü 1":
        return Icons.looks_one;
      case "Menü 2":
        return Icons.looks_two;
      case "Vegetarisches Menü":
        return FB4Icons.seedling;
      default:
        return null;
    }
  }
}
