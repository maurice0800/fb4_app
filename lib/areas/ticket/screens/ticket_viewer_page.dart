import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:file_picker/file_picker.dart';

import '../bloc/ticket_bloc.dart';

class TicketViewerPage extends StatefulWidget {
  TicketViewerPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TicketViewerPageState();
}

class TicketViewerPageState extends State<TicketViewerPage> {
  TicketBloc ticketBloc;

  @override
  void initState() {
    super.initState();
    ticketBloc = BlocProvider.of<TicketBloc>(context);
    ticketBloc.init().then((_) => ticketBloc.add(GetTicketEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Semesterticket",
            style: TextStyle(color: CupertinoColors.white)),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.ellipsis_vertical,
              color: CupertinoColors.white),
          onPressed: () {
            showCupertinoModalPopup(
                context: context,
                builder: (context) => CupertinoActionSheet(
                      actions: [
                        CupertinoActionSheetAction(
                          child: Text("Semesterticket löschen"),
                          isDestructiveAction: true,
                          onPressed: () {
                            ticketBloc.add(DeleteTicketEvent());
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ));
          },
        ),
        backgroundColor: CupertinoTheme.of(context).primaryContrastingColor,
      ),
      child: SafeArea(
        child: buildTicketView(),
      ),
    );
  }

  Widget buildSelectTicket() {
    return Center(
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
                      ticketBloc
                          .add(AddNewTicketEvent(result.files.first.path)),
                    });
              })
        ],
      ),
    );
  }

  Widget buildTicketView() {
    return BlocConsumer<TicketBloc, TicketBlocState>(
      builder: (context, state) {
        if (state is TicketLoadingState || state is TicketInitialState) {
          return Center(child: CupertinoActivityIndicator());
        } else if (state is TicketLoadedState) {
          return Center(
            child: InteractiveViewer(
              child: Image.memory(state.imageBytes),
            ),
          );
        } else if (state is TicketNotFoundState) {
          return buildSelectTicket();
        } else {
          throw Exception("Error while processing BLoC");
        }
      },
      listener: (context, state) {
        if (state is TicketSavedState || state is TicketDeletedState) {
          ticketBloc.add(GetTicketEvent());
        }
      },
    );
  }
}
