import 'package:flutter/cupertino.dart';

class TicketViewerPage extends StatelessWidget {
  const TicketViewerPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Semesterticket",
            style: TextStyle(color: CupertinoColors.white)),
        backgroundColor: CupertinoColors.activeOrange,
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Du hast noch kein Ticket ausgewählt.",
                style: TextStyle(color: CupertinoColors.black),
              ),
              SizedBox(height: 20),
              CupertinoButton.filled(
                  child: Text("Ticket wählen"), onPressed: () {})
            ],
          ),
        ),
      ),
    );
  }
}
