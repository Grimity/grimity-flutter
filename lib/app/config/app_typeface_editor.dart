import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_color.dart';

abstract class AppTypefaceEditor {
  const AppTypefaceEditor._();

  static TextStyle get paragraph =>
      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, height: 24 / 16, color: AppColor.gray800);

  static TextStyle get h1 =>
      TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w700, height: 38 / 32, color: AppColor.gray800);

  static TextStyle get h2 =>
      TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600, height: 30 / 24, color: AppColor.gray800);

  // p { padding-bottom: 6px }
  static const _pBottom = VerticalSpacing(0, 6);

  // h1/h2 { padding-bottom: 14px }
  static const _hBottom = VerticalSpacing(0, 14);

  static const _lineSpacing = VerticalSpacing.zero;

  static const _hSpacing = HorizontalSpacing.zero;

  static DefaultStyles get quillDefaultStyles => DefaultStyles(
    paragraph: DefaultTextBlockStyle(paragraph, _hSpacing, _pBottom, _lineSpacing, null),
    h1: DefaultTextBlockStyle(h1, _hSpacing, _hBottom, _lineSpacing, null),
    h2: DefaultTextBlockStyle(h2, _hSpacing, _hBottom, _lineSpacing, null),
  );
}
