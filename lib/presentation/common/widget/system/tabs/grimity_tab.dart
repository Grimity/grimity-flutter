import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';

enum GrimityTabStatus { on, off }

enum GrimityTabSize { large, medium, small }

class GrimityTab extends StatelessWidget {
  const GrimityTab._({required this.text, this.count, required this.tabStatus, required this.tabSize});

  final String text;
  final int? count;

  final GrimityTabStatus tabStatus;
  final GrimityTabSize tabSize;

  /// large tab
  factory GrimityTab.large({required String text, int? count, GrimityTabStatus tabStatus = GrimityTabStatus.on}) =>
      GrimityTab._(text: text, count: count, tabStatus: tabStatus, tabSize: GrimityTabSize.large);

  /// medium tab
  factory GrimityTab.medium({required String text, int? count, GrimityTabStatus tabStatus = GrimityTabStatus.on}) =>
      GrimityTab._(text: text, count: count, tabStatus: tabStatus, tabSize: GrimityTabSize.medium);

  /// small tab
  factory GrimityTab.small({required String text, int? count, GrimityTabStatus tabStatus = GrimityTabStatus.on}) =>
      GrimityTab._(text: text, count: count, tabStatus: tabStatus, tabSize: GrimityTabSize.small);

  double get _height {
    switch (tabSize) {
      case GrimityTabSize.large:
        return 50.0;
      case GrimityTabSize.medium:
        return 46.0;
      case GrimityTabSize.small:
        return 36.0;
    }
  }

  EdgeInsets get _padding {
    switch (tabSize) {
      case GrimityTabSize.large:
        return EdgeInsets.only(top: 12, bottom: 16, left: 4, right: 4);
      case GrimityTabSize.medium:
        return EdgeInsets.symmetric(vertical: 12, horizontal: 4);
      case GrimityTabSize.small:
        return EdgeInsets.symmetric(vertical: 8, horizontal: 14);
    }
  }

  double get _spacing {
    switch (tabSize) {
      case GrimityTabSize.large:
        return 6.0;
      case GrimityTabSize.medium:
        return 4.0;
      case GrimityTabSize.small:
        return 4.0;
    }
  }

  TextStyle get _textStyle {
    switch (tabSize) {
      case GrimityTabSize.large:
        switch (tabStatus) {
          case GrimityTabStatus.on:
            return AppTypeface.subTitle4.copyWith(color: AppColor.gray700);
          case GrimityTabStatus.off:
            return AppTypeface.body1.copyWith(color: AppColor.gray600);
        }
      case GrimityTabSize.medium:
        switch (tabStatus) {
          case GrimityTabStatus.on:
            return AppTypeface.subTitle4.copyWith(color: AppColor.gray700);
          case GrimityTabStatus.off:
            return AppTypeface.body1.copyWith(color: AppColor.gray600);
        }
      case GrimityTabSize.small:
        switch (tabStatus) {
          case GrimityTabStatus.on:
            return AppTypeface.label1.copyWith(color: AppColor.gray00);
          case GrimityTabStatus.off:
            return AppTypeface.label2.copyWith(color: AppColor.gray700);
        }
    }
  }

  TextStyle get _countStyle {
    switch (tabSize) {
      case GrimityTabSize.large:
        return AppTypeface.label2.copyWith(color: AppColor.gray600);
      case GrimityTabSize.medium:
        return AppTypeface.caption2.copyWith(color: AppColor.gray600);
      case GrimityTabSize.small:
        switch (tabStatus) {
          case GrimityTabStatus.on:
            return AppTypeface.caption2.copyWith(color: AppColor.gray500);
          case GrimityTabStatus.off:
            return AppTypeface.label2.copyWith(color: AppColor.gray600);
        }
    }
  }

  Color? get _backgroundColor {
    switch (tabSize) {
      case GrimityTabSize.large:
      case GrimityTabSize.medium:
        return null;
      case GrimityTabSize.small:
        switch (tabStatus) {
          case GrimityTabStatus.on:
            return AppColor.gray700;
          case GrimityTabStatus.off:
            return AppColor.gray00;
        }
    }
  }

  BorderRadiusGeometry? get _borderRadius {
    switch (tabSize) {
      case GrimityTabSize.large:
      case GrimityTabSize.medium:
        return null;
      case GrimityTabSize.small:
        return BorderRadius.circular(50);
    }
  }

  BoxBorder? get _border {
    switch (tabSize) {
      case GrimityTabSize.large:
      case GrimityTabSize.medium:

        /// large와 medium의 border는 tabbar에서 처리
        // switch (tabStatus) {
        //   case GrimityTabStatus.on:
        //     return Border(bottom: BorderSide(color: AppColor.gray700, width: 2));
        //   case GrimityTabStatus.off:
        //     return Border(bottom: BorderSide(color: AppColor.gray300, width: 1));
        // }
        return null;
      case GrimityTabSize.small:
        switch (tabStatus) {
          case GrimityTabStatus.on:
            return null;
          case GrimityTabStatus.off:
            return Border.all(color: AppColor.gray300, width: 1);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: _height,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: _padding,
        decoration: BoxDecoration(color: _backgroundColor, borderRadius: _borderRadius, border: _border),
        child: Row(
          spacing: _spacing,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [Text(text, style: _textStyle), if (count != null) Text(count.toString(), style: _countStyle)],
        ),
      ),
    );
  }
}
