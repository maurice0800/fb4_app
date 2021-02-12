import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:flutter/cupertino.dart';

class DarkTheme {
  static CupertinoThemeData themeData = CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: ColorConsts.mainOrange,
      primaryContrastingColor: CupertinoColors.systemGrey6,
      textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(color: CupertinoColors.white),
          primaryColor: CupertinoColors.white,
          navTitleTextStyle: TextStyle(
              color: CupertinoColors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              background: null,
              backgroundColor: null,
              debugLabel: "navTitleTextStyle",
              decoration: null,
              decorationColor: null,
              decorationStyle: null,
              decorationThickness: null,
              fontFamily: null,
              fontFamilyFallback: null,
              fontFeatures: null,
              fontStyle: null,
              foreground: null,
              height: null,
              inherit: false,
              letterSpacing: null,
              locale: null,
              package: null,
              shadows: null,
              textBaseline: null,
              wordSpacing: null)));
}