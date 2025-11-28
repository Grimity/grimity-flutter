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
      toolbarHeight: kToolbarHeight.height,
      titleSpacing: 16,
      actionsPadding: EdgeInsets.only(right: 16),
    ),
  );

  static Size get kToolbarHeight => Size.fromHeight(48);

  static Size get kBottomBarHeight => Size.fromHeight(52);
}
