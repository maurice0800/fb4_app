import 'package:fb4_app/api_constants.dart';
import 'package:fb4_app/areas/schedule/viewmodels/add_custom_schedule_item_page_viewmodel.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:fb4_app/core/views/base_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCustomScheduleItemPage extends StatelessWidget {
  const AddCustomScheduleItemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AddCustomScheduleItemPageViewModel>(
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
          middle: const Text(
            "Eigener Eintrag",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: GestureDetector(
            onTap: () {
              if (viewModel.validate()) {
                Navigator.pop(context, viewModel.createNewItem());
              } else {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text("Fehler"),
                    content: const Text(
                      "Es wurden nicht alle erforderlichen Felder ausgefüllt.",
                    ),
                    actions: [
                      GestureDetector(
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "Schließen",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        onTap: () => Navigator.pop(context),
                      )
                    ],
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
        child: CupertinoFormSection(
          backgroundColor: CupertinoColors.tertiarySystemBackground,
          header: const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Kursdetails',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          children: [
            CupertinoTextFormFieldRow(
              controller: viewModel.nameController,
              placeholder: "Kursname",
              validator: (value) => value == "" ? "Pflichtfeld" : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: const TextStyle(fontSize: 16.0),
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 26.0),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      "Wochentag",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
                Container(
                  height: 42,
                  width: 1,
                  color:
                      CupertinoTheme.of(context).brightness == Brightness.light
                          ? CupertinoColors.systemGrey5
                          : CupertinoColors.secondaryLabel,
                ),
                Expanded(
                  child: CupertinoTextFormFieldRow(
                    placeholder: "Auswählen",
                    controller: viewModel.weekdayController,
                    readOnly: true,
                    onTap: () => _showWeekdayPicker(context).then(
                      (result) =>
                          viewModel.weekdayController.text = result ?? "",
                    ),
                    validator: (value) => value == "" ? "Pflichtfeld" : null,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 26.0),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      "Startzeit",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
                Container(
                  height: 42,
                  width: 1,
                  color:
                      CupertinoTheme.of(context).brightness == Brightness.light
                          ? CupertinoColors.systemGrey5
                          : CupertinoColors.secondaryLabel,
                ),
                Expanded(
                  child: CupertinoTextFormFieldRow(
                    placeholder: "Auswählen",
                    readOnly: true,
                    controller: viewModel.timeBeginController,
                    style: const TextStyle(fontSize: 16.0),
                    validator: (value) => value == "" ? "Pflichtfeld" : null,
                    onTap: () => _showTimePicker(context).then(
                      (result) => viewModel.setTimeBegin(result!),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 26.0),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      "Endzeit",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
                Container(
                  height: 42,
                  width: 1,
                  color:
                      CupertinoTheme.of(context).brightness == Brightness.light
                          ? CupertinoColors.systemGrey5
                          : CupertinoColors.secondaryLabel,
                ),
                Expanded(
                  child: CupertinoTextFormFieldRow(
                    placeholder: "Auswählen",
                    readOnly: true,
                    controller: viewModel.timeEndController,
                    style: const TextStyle(fontSize: 16.0),
                    validator: (value) => value == "" ? "Pflichtfeld" : null,
                    onTap: () => _showTimePicker(context).then(
                      (result) => viewModel.setTimeEnd(result!),
                    ),
                  ),
                ),
              ],
            ),
            CupertinoTextFormFieldRow(
              placeholder: "Raum",
              controller: viewModel.roomController,
              style: const TextStyle(fontSize: 16.0),
              validator: (value) => value == "" ? "Pflichtfeld" : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            Row(
              children: [
                Expanded(
                  flex: 12,
                  child: CupertinoTextFormFieldRow(
                    placeholder: "Lehrender",
                    controller: viewModel.lecturerController,
                    style: const TextStyle(fontSize: 16.0),
                    validator: (value) => value == "" ? "Pflichtfeld" : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                Container(
                  height: 42,
                  width: 1,
                  color:
                      CupertinoTheme.of(context).brightness == Brightness.light
                          ? CupertinoColors.systemGrey5
                          : CupertinoColors.secondaryLabel,
                ),
                Expanded(
                  flex: 7,
                  child: CupertinoTextFormFieldRow(
                    placeholder: "Kürzel",
                    controller: viewModel.shortlecturerController,
                    style: const TextStyle(fontSize: 16.0),
                    validator: (value) => value == "" ? "Pflichtfeld" : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLength: 5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _showTimePicker(BuildContext context) async {
    return showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (context) {
        DateTime pickedTime = DateTime.now();
        return SizedBox(
          height: 250,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    child: const Text('Abbrechen'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoButton(
                    child: const Text('Fertig'),
                    onPressed: () {
                      Navigator.of(context).pop(pickedTime);
                    },
                  ),
                ],
              ),
              const Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: CupertinoDatePicker(
                  use24hFormat: true,
                  mode: CupertinoDatePickerMode.time,
                  onDateTimeChanged: (DateTime dateTime) {
                    pickedTime = dateTime;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> _showWeekdayPicker(BuildContext context) async {
    return showCupertinoModalPopup<String>(
      context: context,
      builder: (context) {
        String tempWeekday = longWeekDays.keys.first;
        return SizedBox(
          height: 250,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    child: const Text('Abbrechen'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoButton(
                    child: const Text('Fertig'),
                    onPressed: () {
                      Navigator.of(context).pop(tempWeekday);
                    },
                  ),
                ],
              ),
              const Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 36,
                  onSelectedItemChanged: (index) {
                    tempWeekday = longWeekDays.keys.elementAt(index);
                  },
                  children: longWeekDays.keys
                      .map((e) => Center(child: Text(e)))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
