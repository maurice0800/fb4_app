import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:flutter/cupertino.dart';

class CanteenOverview extends StatelessWidget {
  const CanteenOverview({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: ColorConsts.mainOrange,
          middle: Text("Mensa"),
        ),
        child: Center(
          child: Text(
            "COMING SOON",
            style: CupertinoTheme.of(context).textTheme.textStyle,
          ),
        ));
  }
}
