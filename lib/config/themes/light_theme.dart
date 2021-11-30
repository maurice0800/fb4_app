import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:flutter/cupertino.dart';

CupertinoThemeData lightThemeData = const CupertinoThemeData(
  brightness: Brightness.light,
  primaryColor: ColorConsts.mainOrange,
  primaryContrastingColor: CupertinoColors.white,
  textTheme: CupertinoTextThemeData(
    textStyle: TextStyle(
      color: CupertinoColors.black,
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
