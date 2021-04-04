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
                  () => viewModel.deleteSchedule(context)),
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
              CSButton(CSButtonType.DESTRUCTIVE, "Ticket löschen",
                  () => viewModel.deleteTicket(context)),
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
}
