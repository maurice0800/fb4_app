import 'package:fb4_app/areas/ticket/viewmodels/ticket_overview_viewmodel.dart';

import 'package:flutter/cupertino.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

class TicketViewerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Semesterticket",
            style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
        trailing: Consumer<TicketOverviewViewModel>(
          builder: (context, viewModel, child) => CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.ellipsis_vertical,
                color: CupertinoTheme.of(context)
                    .textTheme
                    .navTitleTextStyle
                    .color),
            onPressed: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                        actions: [
                          CupertinoActionSheetAction(
                            child: Text("Semesterticket löschen"),
                            isDestructiveAction: true,
                            onPressed: () {
                              viewModel.deleteTicket();
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ));
            },
          ),
        ),
        backgroundColor: CupertinoTheme.of(context).primaryContrastingColor,
      ),
      child: SafeArea(
        child: buildTicketView(context),
      ),
    );
  }

  Widget buildSelectTicket(BuildContext context) {
    return Consumer<TicketOverviewViewModel>(
      builder: (context, viewModel, child) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Du hast noch kein Ticket ausgewählt.",
              style: CupertinoTheme.of(context).textTheme.textStyle,
            ),
            SizedBox(height: 20),
            CupertinoButton.filled(
                child: Text("Ticket wählen",
                    style: TextStyle(color: CupertinoColors.white)),
                onPressed: () {
                  FilePicker.platform.pickFiles().then((result) => {
                        viewModel.extractImageFromPdf(result.files.first.path),
                      });
                })
          ],
        ),
      ),
    );
  }

  Widget buildTicketView(BuildContext context) {
    return Consumer<TicketOverviewViewModel>(
        builder: (context, viewModel, child) {
      if (viewModel.isImageProcessing) {
        return Center(
          child: CupertinoActivityIndicator(),
        );
      }

      if (viewModel.isImageAvailable) {
        return Center(
          child: InteractiveViewer(
            child: Image.memory(viewModel.imageBytes),
          ),
        );
      }

      return buildSelectTicket(context);
    });
  }
}
