import 'package:flutter/cupertino.dart';

class LightTheme {
  static CupertinoThemeData themeData = CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: CupertinoColors.activeOrange,
      primaryContrastingColor: CupertinoColors.white,
      barBackgroundColor: CupertinoColors.activeOrange,
      textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(color: CupertinoColors.black),
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
