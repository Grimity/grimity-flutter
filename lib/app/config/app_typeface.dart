import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_color.dart';

abstract class AppTypeface {
  const AppTypeface._();

  // Display
  static TextStyle get display1 =>
      TextStyle(fontWeight: FontWeight.w700, fontSize: 56, height: 1.4, letterSpacing: -0.3, color: AppColor.gray800);

  static TextStyle get display2 =>
      TextStyle(fontWeight: FontWeight.w700, fontSize: 40, height: 1.4, letterSpacing: -0.3, color: AppColor.gray800);

  // Title
  static TextStyle get title1 => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 36.sp,
    height: 1.4,
    letterSpacing: -0.3,
    color: AppColor.gray800,
  );

  static TextStyle get title2 => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 28.sp,
    height: 1.4,
    letterSpacing: -0.3,
    color: AppColor.gray800,
  );

  static TextStyle get title3 => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 24.sp,
    height: 1.4,
    letterSpacing: -0.3,
    color: AppColor.gray800,
  );

  static TextStyle get title4 => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 20.sp,
    height: 1.4,
    letterSpacing: -0.3,
    color: AppColor.gray800,
  );

  static TextStyle get title5 => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 20.sp,
    height: 1.4,
    letterSpacing: -0.3,
    color: AppColor.gray800,
  );

  // SubTitle
  static TextStyle get subTitle1 => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18.sp,
    height: 1.4,
    letterSpacing: -0.3,
    color: AppColor.gray800,
  );

  static TextStyle get subTitle2 => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 18.sp,
    height: 1.4,
    letterSpacing: -0.3,
    color: AppColor.gray800,
  );

  static TextStyle get subTitle3 => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16.sp,
    height: 1.4,
    letterSpacing: -0.3,
    color: AppColor.gray800,
  );

  static TextStyle get subTitle4 => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16.sp,
    height: 1.4,
    letterSpacing: -0.3,
    color: AppColor.gray800,
  );

  // Body
  static TextStyle get body1 =>
      TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp, height: 1.4, color: AppColor.gray800);

  static TextStyle get body2 =>
      TextStyle(fontWeight: FontWeight.w400, fontSize: 16.sp, height: 1.4, color: AppColor.gray800);

  // Label
  static TextStyle get label1 =>
      TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp, height: 1.4, color: AppColor.gray800);

  static TextStyle get label2 =>
      TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp, height: 1.4, color: AppColor.gray800);

  static TextStyle get label3 =>
      TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp, height: 1.4, color: AppColor.gray800);

  // Caption
  static TextStyle get caption1 =>
      TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp, height: 1.4, color: AppColor.gray800);

  static TextStyle get caption2 =>
      TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp, height: 1.4, color: AppColor.gray800);

  static TextStyle get caption3 =>
      TextStyle(fontWeight: FontWeight.w600, fontSize: 11.sp, height: 1.4, color: AppColor.gray800);

  static TextStyle get caption4 =>
      TextStyle(fontWeight: FontWeight.w500, fontSize: 10.sp, height: 1.4, color: AppColor.gray800);

  // Button
  static TextStyle get button1 => TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp, color: AppColor.gray800);

  static TextStyle get button2 => TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp, color: AppColor.gray800);

  static TextStyle get button3 => TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp, color: AppColor.gray800);
}
