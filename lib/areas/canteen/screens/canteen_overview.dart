import 'package:flutter/cupertino.dart';

class CanteenOverview extends StatelessWidget {
  const CanteenOverview({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
      child: Text(
        "COMING SOON",
        style: TextStyle(color: CupertinoColors.black),
      ),
    ));
  }
}
