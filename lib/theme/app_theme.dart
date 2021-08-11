import 'package:flutter/material.dart';

import '../utils/size_config.dart';

class AppTheme {

  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    textTheme: TextTheme(
    headline1: TextStyle(fontSize: 3.25 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.w700, color: Colors.black, height: .1625 * SizeConfig.heightSizeMultiplier), //headline1, 26
    headline2: TextStyle(fontSize: 3 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.w700, color: Colors.black, height: .1625 * SizeConfig.heightSizeMultiplier), //headline2, 24
    headline3: TextStyle(fontSize: 2.75 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.w500, color: Colors.black, height: .1625 * SizeConfig.heightSizeMultiplier), //headline3, 22
    headline4: TextStyle(fontSize: 2.5 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.w500, color: Colors.black, height: .1625 * SizeConfig.heightSizeMultiplier), //headline4, 20
    headline5: TextStyle(fontSize: 2.25 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.w500, color: Colors.black, height: .1625 * SizeConfig.heightSizeMultiplier), //headline5, 18
    headline6: TextStyle(fontSize: 2 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.w700, color: Colors.black, height: .1625 * SizeConfig.heightSizeMultiplier), //headline6, 16
    subtitle1: TextStyle(fontSize: 1.875 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.w500, color: Colors.black, height: .1625 * SizeConfig.heightSizeMultiplier), //subtitle1, 15
    subtitle2: TextStyle(fontSize: 1.625 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.normal, color: Colors.black, height: .1625 * SizeConfig.heightSizeMultiplier), //subtitle2, 13
    bodyText1: TextStyle(fontSize: 1.25 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.w500, color: Colors.black, height: .15 * SizeConfig.heightSizeMultiplier), //body2, 10
    bodyText2: TextStyle(fontSize: 1.0625 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.normal, color: Colors.black, height: .15 * SizeConfig.heightSizeMultiplier), //body1, 8.5
    caption: TextStyle(fontSize: 1.75 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.w400, color: Colors.black38, height: .15 * SizeConfig.heightSizeMultiplier), //caption, 14
    ),
  );


  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 3.25 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.w700, color: Colors.white, height: .1625 * SizeConfig.heightSizeMultiplier), //headline1, 26
      headline2: TextStyle(fontSize: 3 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.w700, color: Colors.white, height: .1625 * SizeConfig.heightSizeMultiplier), //headline2, 24
      headline3: TextStyle(fontSize: 2.75 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.w500, color: Colors.white, height: .1625 * SizeConfig.heightSizeMultiplier), //headline3, 22
      headline4: TextStyle(fontSize: 2.5 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.w500, color: Colors.white, height: .1625 * SizeConfig.heightSizeMultiplier), //headline4, 20
      headline5: TextStyle(fontSize: 2.25 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.w500, color: Colors.white, height: .1625 * SizeConfig.heightSizeMultiplier), //headline5, 18
      headline6: TextStyle(fontSize: 2 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.w700, color: Colors.white, height: .1625 * SizeConfig.heightSizeMultiplier), //headline6, 16
      subtitle1: TextStyle(fontSize: 1.875 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.w500, color: Colors.white, height: .1625 * SizeConfig.heightSizeMultiplier), //subtitle1, 15
      subtitle2: TextStyle(fontSize: 1.625 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.normal, color: Colors.white, height: .1625 * SizeConfig.heightSizeMultiplier), //subtitle2, 13
      bodyText1: TextStyle(fontSize: 1.25 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.w500, color: Colors.white, height: .15 * SizeConfig.heightSizeMultiplier), //body2, 10
      bodyText2: TextStyle(fontSize: 1.0625 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.normal, color: Colors.white, height: .15 * SizeConfig.heightSizeMultiplier), //body1, 8.5
      caption: TextStyle(fontSize: 1.75 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.w400, color: Colors.black12, height: .15 * SizeConfig.heightSizeMultiplier), //caption, 14
    ),
  );
}