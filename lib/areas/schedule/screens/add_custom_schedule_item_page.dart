import 'package:fb4_app/api_constants.dart';
import 'package:fb4_app/areas/schedule/viewmodels/add_custom_schedule_item_page_viewmodel.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCustomScheduleItemPage extends StatelessWidget {
  const AddCustomScheduleItemPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddCustomScheduleItemPageViewModel>(
        create: (context) => AddCustomScheduleItemPageViewModel(),
        builder: (context, child) => Consumer<
                AddCustomScheduleItemPageViewModel>(
            builder: (context, viewModel, child) => CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    backgroundColor: ColorConsts.mainOrange,
                    middle: Text("Eigener Eintrag",
                        style: TextStyle(fontWeight: FontWeight.normal)),
                    trailing: GestureDetector(
                      onTap: () {
                        if (viewModel.validate()) {
                          Navigator.pop(context, viewModel.createNewItem());
                        } else {
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
                        }
                      },
                      child: Text(
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
                      header: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Kursdetails',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      children: [
                        CupertinoTextFormFieldRow(
                          controller: viewModel.nameController,
                          placeholder: "Kursname",
                          textAlign: TextAlign.start,
                          validator: (value) =>
                              value == "" ? "Pflichtfeld" : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        CupertinoTextFormFieldRow(
                          prefix: SizedBox(
                            width: 100,
                            child: Text(
                              "Tag",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          placeholder: "Auswählen",
                          controller: viewModel.weekdayController,
                          readOnly: true,
                          onTap: () => _showWeekdayPicker(context).then(
                              (result) =>
                                  viewModel.weekdayController.text = result),
                          validator: (value) =>
                              value == "" ? "Pflichtfeld" : null,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        CupertinoTextFormFieldRow(
                          prefix: SizedBox(
                            width: 100,
                            child: Text(
                              "Startzeit",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          placeholder: "Auswählen",
                          readOnly: true,
                          controller: viewModel.timeBeginController,
                          style: TextStyle(fontSize: 16.0),
                          validator: (value) =>
                              value == "" ? "Pflichtfeld" : null,
                          onTap: () => _showTimePicker(context)
                              .then((result) => viewModel.setTimeBegin(result)),
                        ),
                        CupertinoTextFormFieldRow(
                          prefix: SizedBox(
                            width: 100,
                            child: Text(
                              "Endzeit",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          placeholder: "Auswählen",
                          readOnly: true,
                          controller: viewModel.timeEndController,
                          style: TextStyle(fontSize: 16.0),
                          validator: (value) =>
                              value == "" ? "Pflichtfeld" : null,
                          onTap: () => _showTimePicker(context)
                              .then((result) => viewModel.setTimeEnd(result)),
                        ),
                        CupertinoTextFormFieldRow(
                          placeholder: "Raum",
                          controller: viewModel.roomController,
                          style: TextStyle(fontSize: 16.0),
                          validator: (value) =>
                              value == "" ? "Pflichtfeld" : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 12,
                              child: CupertinoTextFormFieldRow(
                                placeholder: "Lehrender",
                                controller: viewModel.lecturerController,
                                style: TextStyle(fontSize: 16.0),
                                validator: (value) =>
                                    value == "" ? "Pflichtfeld" : null,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: CupertinoTextFormFieldRow(
                                placeholder: "Kürzel",
                                controller: viewModel.shortlecturerController,
                                style: TextStyle(fontSize: 16.0),
                                validator: (value) =>
                                    value == "" ? "Pflichtfeld" : null,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                maxLength: 5,
                              ),
                            ),
                          ],
                        ),
                      ]),
                )));
  }

  Future<DateTime> _showTimePicker(BuildContext context) async {
    return showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (context) {
        DateTime pickedTime = DateTime.now();
        return Container(
          height: 250,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text('Abbrechen'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: Text('Fertig'),
                      onPressed: () {
                        Navigator.of(context).pop(pickedTime);
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: Container(
                  child: CupertinoDatePicker(
                    use24hFormat: true,
                    mode: CupertinoDatePickerMode.time,
                    onDateTimeChanged: (DateTime dateTime) {
                      pickedTime = dateTime;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> _showWeekdayPicker(BuildContext context) async {
    return showCupertinoModalPopup<String>(
      context: context,
      builder: (context) {
        String tempWeekday = ApiConstants.longWeekDays.keys.first;
        return Container(
          height: 250,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text('Abbrechen'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: Text('Fertig'),
                      onPressed: () {
                        Navigator.of(context).pop(tempWeekday);
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: Container(
                  child: CupertinoPicker(
                    children: ApiConstants.longWeekDays.keys
                        .map((e) => Center(child: Text(e)))
                        .toList(),
                    itemExtent: 36,
                    onSelectedItemChanged: (index) {
                      tempWeekday =
                          ApiConstants.longWeekDays.keys.elementAt(index);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
