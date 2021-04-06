import 'dart:async';

import 'package:fb4_app/areas/more/viewmodels/settings_page_view_model.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: ColorConsts.mainOrange,
          middle: Text("Einstellungen"),
        ),
        child: Consumer<SettingsPageViewModel>(
          builder: (context, viewModel, child) => CupertinoSettings(
            items: [
              CSHeader("Stundenplan"),
              CSButton(CSButtonType.DESTRUCTIVE, "Stundenplan löschen",
                  () async {
                var result = await showConfirmDialog(
                    context, "Soll der Stundenplan wirklich gelöscht werden?");
                if (result) {
                  viewModel.deleteSchedule(context);
                }
                Navigator.pop(context);
              }),
              CSHeader("NRW-Ticket"),
              CSControl(
                nameWidget: Text("Helligkeit erhöhen"),
                contentWidget: CupertinoSwitch(
                  value: viewModel.increaseDisplayBrightnessInTicketview,
                  onChanged: (value) {
                    viewModel.increaseDisplayBrightnessInTicketview = value;
                  },
                ),
              ),
              CSButton(CSButtonType.DESTRUCTIVE, "Ticket löschen", () async {
                var result = await showConfirmDialog(
                    context, "Soll das Ticket wirklich gelöscht werden?");
                if (result) {
                  viewModel.deleteTicket(context);
                }
                Navigator.pop(context);
              }),
              CSHeader("Sonstiges"),
              CSControl(
                nameWidget: Text("Benachrichtigungen bei News"),
                contentWidget: CupertinoSwitch(
                  value: viewModel.notificationOnNews,
                  onChanged: (value) => viewModel.notificationOnNews = value,
                ),
              )
            ],
          ),
        ));
  }

  Future<bool> showConfirmDialog(BuildContext context, String message) {
    Completer<bool> completer = Completer<bool>();
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text("Bestätigung"),
              content: Text(message),
              actions: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Ja",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  onTap: () {
                    completer.complete(true);
                  },
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Nein",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  onTap: () {
                    completer.complete(false);
                  },
                )
              ],
            ));
    return completer.future;
  }
}
