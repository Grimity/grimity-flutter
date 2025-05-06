import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_typeface.dart';

class AppTheme {
  static final ThemeData appTheme = ThemeData(
    fontFamily: 'Pretendard',
    scaffoldBackgroundColor: Colors.white,
    splashFactory: NoSplash.splashFactory,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTypeface.subTitle3,
    ),
  );
}
