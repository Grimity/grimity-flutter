import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/button/grimity_button.dart';

class GrimityStateView extends StatelessWidget {
  const GrimityStateView._({
    required this.icon,
    this.title,
    this.subTitle,
    this.buttonText,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 80),
    this.buttonPrefixIcon,
    this.buttonSuffixIcon,
    this.buttonSize = ButtonSize.medium,
    this.buttonStatus = ButtonStatus.on,
    this.buttonColorType = ButtonColorType.mono,
    this.buttonStyleType = ButtonStyleType.solid,
  });

  final SvgGenImage icon;
  final String? title;
  final String? subTitle;
  final String? buttonText;
  final VoidCallback? onTap;

  // padding
  final EdgeInsetsGeometry padding;

  // button 속성
  final SvgGenImage? buttonPrefixIcon;
  final SvgGenImage? buttonSuffixIcon;
  final ButtonSize buttonSize;
  final ButtonStatus buttonStatus;
  final ButtonColorType buttonColorType;
  final ButtonStyleType buttonStyleType;

  /// user icon
  factory GrimityStateView.user({
    String? title,
    String? subTitle,
    String? buttonText,
    VoidCallback? onTap,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 80),
    SvgGenImage? buttonPrefixIcon,
    SvgGenImage? buttonSuffixIcon,
    ButtonSize buttonSize = ButtonSize.medium,
    ButtonStatus buttonStatus = ButtonStatus.on,
    ButtonColorType buttonColor = ButtonColorType.mono,
    ButtonStyleType buttonStyleType = ButtonStyleType.solid,
  }) => GrimityStateView._(
    icon: Assets.icons.common.user,
    title: title,
    subTitle: subTitle,
    buttonText: buttonText,
    onTap: onTap,
    padding: padding,
    buttonPrefixIcon: buttonPrefixIcon,
    buttonSuffixIcon: buttonSuffixIcon,
    buttonSize: buttonSize,
    buttonStatus: buttonStatus,
    buttonColorType: buttonColor,
    buttonStyleType: buttonStyleType,
  );

  /// resultNull icon
  factory GrimityStateView.resultNull({
    String? title,
    String? subTitle,
    String? buttonText,
    VoidCallback? onTap,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 80),
    SvgGenImage? buttonPrefixIcon,
    SvgGenImage? buttonSuffixIcon,
    ButtonSize buttonSize = ButtonSize.medium,
    ButtonStatus buttonStatus = ButtonStatus.on,
    ButtonColorType buttonColor = ButtonColorType.mono,
    ButtonStyleType buttonStyleType = ButtonStyleType.solid,
  }) => GrimityStateView._(
    icon: Assets.icons.common.resultNull,
    title: title,
    subTitle: subTitle,
    buttonText: buttonText,
    onTap: onTap,
    padding: padding,
    buttonPrefixIcon: buttonPrefixIcon,
    buttonSuffixIcon: buttonSuffixIcon,
    buttonSize: buttonSize,
    buttonStatus: buttonStatus,
    buttonColorType: buttonColor,
    buttonStyleType: buttonStyleType,
  );

  /// illust icon
  factory GrimityStateView.illust({
    String? title,
    String? subTitle,
    String? buttonText,
    VoidCallback? onTap,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 80),
    SvgGenImage? buttonPrefixIcon,
    SvgGenImage? buttonSuffixIcon,
    ButtonSize buttonSize = ButtonSize.medium,
    ButtonStatus buttonStatus = ButtonStatus.on,
    ButtonColorType buttonColor = ButtonColorType.mono,
    ButtonStyleType buttonStyleType = ButtonStyleType.solid,
  }) => GrimityStateView._(
    icon: Assets.icons.common.illust,
    title: title,
    subTitle: subTitle,
    buttonText: buttonText,
    onTap: onTap,
    padding: padding,
    buttonPrefixIcon: buttonPrefixIcon,
    buttonSuffixIcon: buttonSuffixIcon,
    buttonSize: buttonSize,
    buttonStatus: buttonStatus,
    buttonColorType: buttonColor,
    buttonStyleType: buttonStyleType,
  );

  /// commentReply icon
  factory GrimityStateView.commentReply({
    String? title,
    String? subTitle,
    String? buttonText,
    VoidCallback? onTap,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 80),
    SvgGenImage? buttonPrefixIcon,
    SvgGenImage? buttonSuffixIcon,
    ButtonSize buttonSize = ButtonSize.medium,
    ButtonStatus buttonStatus = ButtonStatus.on,
    ButtonColorType buttonColor = ButtonColorType.mono,
    ButtonStyleType buttonStyleType = ButtonStyleType.solid,
  }) => GrimityStateView._(
    icon: Assets.icons.common.commentReply,
    title: title,
    subTitle: subTitle,
    buttonText: buttonText,
    onTap: onTap,
    padding: padding,
    buttonPrefixIcon: buttonPrefixIcon,
    buttonSuffixIcon: buttonSuffixIcon,
    buttonSize: buttonSize,
    buttonStatus: buttonStatus,
    buttonColorType: buttonColor,
    buttonStyleType: buttonStyleType,
  );

  /// warning icon
  factory GrimityStateView.warning({
    String? title,
    String? subTitle,
    String? buttonText,
    VoidCallback? onTap,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 80),
    SvgGenImage? buttonPrefixIcon,
    SvgGenImage? buttonSuffixIcon,
    ButtonSize buttonSize = ButtonSize.medium,
    ButtonStatus buttonStatus = ButtonStatus.on,
    ButtonColorType buttonColor = ButtonColorType.mono,
    ButtonStyleType buttonStyleType = ButtonStyleType.solid,
  }) => GrimityStateView._(
    icon: Assets.icons.common.warning,
    title: title,
    subTitle: subTitle,
    buttonText: buttonText,
    onTap: onTap,
    padding: padding,
    buttonPrefixIcon: buttonPrefixIcon,
    buttonSuffixIcon: buttonSuffixIcon,
    buttonSize: buttonSize,
    buttonStatus: buttonStatus,
    buttonColorType: buttonColor,
    buttonStyleType: buttonStyleType,
  );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            icon.svg(width: 60, height: 60),
            Column(
              spacing: 8,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: AppTypeface.subTitle3.copyWith(color: AppColor.gray700),
                    textAlign: TextAlign.center,
                  ),
                if (subTitle != null)
                  Text(
                    subTitle!,
                    style: AppTypeface.label2.copyWith(color: AppColor.gray600),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
            if (buttonText != null && onTap != null)
              switch (buttonSize) {
                ButtonSize.large => GrimityButton.large(
                  text: buttonText!,
                  onTap: onTap,
                  prefixIcon: buttonPrefixIcon,
                  suffixIcon: buttonSuffixIcon,
                  status: buttonStatus,
                  color: buttonColorType,
                  style: buttonStyleType,
                ),
                ButtonSize.medium => GrimityButton.medium(
                  text: buttonText!,
                  onTap: onTap,
                  prefixIcon: buttonPrefixIcon,
                  suffixIcon: buttonSuffixIcon,
                  status: buttonStatus,
                  color: buttonColorType,
                  style: buttonStyleType,
                ),
                ButtonSize.small => GrimityButton.small(
                  text: buttonText!,
                  onTap: onTap,
                  prefixIcon: buttonPrefixIcon,
                  suffixIcon: buttonSuffixIcon,
                  status: buttonStatus,
                  color: buttonColorType,
                  style: buttonStyleType,
                ),
                ButtonSize.round => GrimityButton.round(
                  text: buttonText!,
                  onTap: onTap,
                  prefixIcon: buttonPrefixIcon,
                  suffixIcon: buttonSuffixIcon,
                  status: buttonStatus,
                  color: buttonColorType,
                  style: buttonStyleType,
                ),
              },
          ],
        ),
      ),
    );
  }
}
