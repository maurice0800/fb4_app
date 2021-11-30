import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:flutter/cupertino.dart';

CupertinoThemeData darkThemeData = const CupertinoThemeData(
  brightness: Brightness.dark,
  primaryColor: ColorConsts.mainOrange,
  primaryContrastingColor: CupertinoColors.systemGrey6,
  textTheme: CupertinoTextThemeData(
    textStyle: TextStyle(
      color: CupertinoColors.white,
      fontSize: 14,
    ),
    primaryColor: CupertinoColors.white,
    navTitleTextStyle: TextStyle(
      color: CupertinoColors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      debugLabel: "navTitleTextStyle",
      inherit: false,
    ),
  ),
);
