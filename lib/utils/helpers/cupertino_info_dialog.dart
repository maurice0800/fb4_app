import 'package:flutter/cupertino.dart';

class CupertinoInfoDialog {
  final BuildContext context;
  final String title;
  final String message;

  CupertinoInfoDialog(this.context, this.title, this.message);

  void show() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "OK",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
