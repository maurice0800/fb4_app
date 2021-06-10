import 'dart:async';

import 'package:fb4_app/areas/more/viewmodels/settings_page_view_model.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:fb4_app/core/views/base_view.dart';
import 'package:fb4_app/utils/helpers/cupertino_info_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: ColorConsts.mainOrange,
          middle: const Text("Einstellungen"),
        ),
        child: BaseView<SettingsPageViewModel>(
          onViewModelCreated: (viewModel) => viewModel.init(),
          builder: (context, viewModel, child) => CupertinoSettings(
            items: [
              const CSHeader("Stundenplan"),
              CSControl(
                nameWidget: const Text("Aktuellen Wochentag zuerst zeigen"),
                contentWidget: CupertinoSwitch(
                  value: viewModel.goToCurrentDayInSchedule,
                  onChanged: (value) {
                    viewModel.goToCurrentDayInSchedule = value;
                  },
                ),
              ),
              CSButton(CSButtonType.DESTRUCTIVE, "Stundenplan löschen",
                  () async {
                final result = await showConfirmDialog(
                    context, "Soll der Stundenplan wirklich gelöscht werden?");
                if (result) {
                  viewModel.deleteSchedule(context);
                }
                Navigator.pop(context);
              }),
              const CSHeader("NRW-Ticket"),
              CSControl(
                nameWidget: const Text("Helligkeit erhöhen"),
                contentWidget: CupertinoSwitch(
                  value: viewModel.increaseDisplayBrightnessInTicketview,
                  onChanged: (value) {
                    viewModel.increaseDisplayBrightnessInTicketview = value;
                  },
                ),
              ),
              CSButton(CSButtonType.DESTRUCTIVE, "Ticket löschen", () async {
                final result = await showConfirmDialog(
                    context, "Soll das Ticket wirklich gelöscht werden?");
                if (result) {
                  viewModel.deleteTicket(context);
                }
                Navigator.pop(context);
              }),
              const CSHeader("ODS"),
              CSButton(CSButtonType.DESTRUCTIVE, "Anmeldedaten löschen",
                  () async {
                await viewModel.logoutOds();
                CupertinoInfoDialog(
                        context, "Erfolgreich", "Logout erfolgreich.")
                    .show();
              }),
              const CSHeader("Sonstiges"),
              CSControl(
                nameWidget: const Text("Benachrichtigungen bei News"),
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
    final Completer<bool> completer = Completer<bool>();
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text("Bestätigung"),
              content: Text(message),
              actions: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    completer.complete(true);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Ja",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    completer.complete(false);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Nein",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ));
    return completer.future;
  }
}
