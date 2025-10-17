import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';

enum ButtonSize { large, medium, small, round }

enum ButtonStatus { on, off }

enum ButtonColorType { mono, secondary }

enum ButtonStyleType { solid, line }

class GrimityButton extends StatelessWidget {
  const GrimityButton._({
    required this.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    required this.buttonSize,
    required this.buttonStatus,
    required this.buttonColorType,
    required this.buttonStyleType,
    super.key,
  });

  final String text;
  final SvgGenImage? prefixIcon;
  final SvgGenImage? suffixIcon;
  final VoidCallback? onTap;

  final ButtonSize buttonSize;
  final ButtonStatus buttonStatus;
  final ButtonColorType buttonColorType;
  final ButtonStyleType buttonStyleType;

  /// large button
  factory GrimityButton.large({
    required String text,
    SvgGenImage? prefixIcon,
    SvgGenImage? suffixIcon,
    VoidCallback? onTap,
    ButtonStatus status = ButtonStatus.on,
    ButtonColorType color = ButtonColorType.mono,
    ButtonStyleType style = ButtonStyleType.solid,
    Key? key,
  }) => GrimityButton._(
    key: key,
    text: text,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    onTap: onTap,
    buttonSize: ButtonSize.large,
    buttonStatus: status,
    buttonColorType: color,
    buttonStyleType: style,
  );

  /// medium button
  factory GrimityButton.medium({
    required String text,
    SvgGenImage? prefixIcon,
    SvgGenImage? suffixIcon,
    VoidCallback? onTap,
    ButtonStatus status = ButtonStatus.on,
    ButtonColorType color = ButtonColorType.mono,
    ButtonStyleType style = ButtonStyleType.solid,
    Key? key,
  }) => GrimityButton._(
    key: key,
    text: text,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    onTap: onTap,
    buttonSize: ButtonSize.medium,
    buttonStatus: status,
    buttonColorType: color,
    buttonStyleType: style,
  );

  /// small button
  factory GrimityButton.small({
    required String text,
    SvgGenImage? prefixIcon,
    SvgGenImage? suffixIcon,
    VoidCallback? onTap,
    ButtonStatus status = ButtonStatus.on,
    ButtonColorType color = ButtonColorType.mono,
    ButtonStyleType style = ButtonStyleType.solid,
    Key? key,
  }) => GrimityButton._(
    key: key,
    text: text,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    onTap: onTap,
    buttonSize: ButtonSize.small,
    buttonStatus: status,
    buttonColorType: color,
    buttonStyleType: style,
  );

  /// rounded button
  factory GrimityButton.round({
    required String text,
    SvgGenImage? prefixIcon,
    SvgGenImage? suffixIcon,
    VoidCallback? onTap,
    ButtonStatus status = ButtonStatus.on,
    ButtonColorType color = ButtonColorType.mono,
    ButtonStyleType style = ButtonStyleType.solid,
    Key? key,
  }) => GrimityButton._(
    key: key,
    text: text,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    onTap: onTap,
    buttonSize: ButtonSize.round,
    buttonStatus: status,
    buttonColorType: color,
    buttonStyleType: style,
  );

  /// follow button
  factory GrimityButton.follow({Key? key, required bool isFollowing, required VoidCallback onTap}) => GrimityButton._(
    key: key,
    text: isFollowing ? '언팔로우' : '팔로우',
    onTap: onTap,
    buttonSize: ButtonSize.round,
    buttonStatus: ButtonStatus.on,
    buttonColorType: ButtonColorType.mono,
    buttonStyleType: isFollowing ? ButtonStyleType.line : ButtonStyleType.solid,
  );

  /// delete follow button
  factory GrimityButton.deleteFollower({Key? key, required VoidCallback onTap}) => GrimityButton._(
    key: key,
    text: '삭제',
    onTap: onTap,
    buttonSize: ButtonSize.round,
    buttonStatus: ButtonStatus.on,
    buttonColorType: ButtonColorType.mono,
    buttonStyleType: ButtonStyleType.line,
  );

  BorderRadius get _borderRadius {
    switch (buttonSize) {
      case ButtonSize.large:
        return BorderRadius.circular(12);
      case ButtonSize.medium:
        return BorderRadius.circular(10);
      case ButtonSize.small:
        return BorderRadius.circular(8);
      case ButtonSize.round:
        return BorderRadius.circular(50);
    }
  }

  Color get _backgroundColor {
    switch (buttonSize) {
      case ButtonSize.large:
      case ButtonSize.medium:
      case ButtonSize.small:
        switch (buttonStatus) {
          case ButtonStatus.on:
            switch (buttonStyleType) {
              case ButtonStyleType.solid:
                return AppColor.primary4;
              case ButtonStyleType.line:
                return AppColor.gray00;
            }
          case ButtonStatus.off:
            switch (buttonStyleType) {
              case ButtonStyleType.solid:
                return AppColor.gray300;
              case ButtonStyleType.line:
                return AppColor.gray00;
            }
        }
      case ButtonSize.round:
        switch (buttonStatus) {
          case ButtonStatus.on:
            switch (buttonColorType) {
              case ButtonColorType.mono:
                switch (buttonStyleType) {
                  case ButtonStyleType.solid:
                    return AppColor.primary4;
                  case ButtonStyleType.line:
                    return AppColor.gray00;
                }
              case ButtonColorType.secondary:
                switch (buttonStyleType) {
                  case ButtonStyleType.solid:
                    return AppColor.main;
                  case ButtonStyleType.line:
                    return AppColor.gray00;
                }
            }
          case ButtonStatus.off:
            switch (buttonColorType) {
              case ButtonColorType.mono:
                switch (buttonStyleType) {
                  case ButtonStyleType.solid:
                    return AppColor.gray300;
                  case ButtonStyleType.line:
                    throw UnimplementedError();
                }
              case ButtonColorType.secondary:
                switch (buttonStyleType) {
                  case ButtonStyleType.solid:
                    throw UnimplementedError();
                  case ButtonStyleType.line:
                    return AppColor.gray00;
                }
            }
        }
    }
  }

  BoxBorder? get _border {
    switch (buttonSize) {
      case ButtonSize.large:
      case ButtonSize.medium:
      case ButtonSize.small:
        switch (buttonStatus) {
          case ButtonStatus.on:
            switch (buttonStyleType) {
              case ButtonStyleType.solid:
                return null;
              case ButtonStyleType.line:
                return Border.all(color: AppColor.gray300, width: 1);
            }
          case ButtonStatus.off:
            switch (buttonStyleType) {
              case ButtonStyleType.solid:
                return Border.all(color: AppColor.gray300, width: 1);
              case ButtonStyleType.line:
                return Border.all(color: AppColor.gray300, width: 1);
            }
        }
      case ButtonSize.round:
        switch (buttonStatus) {
          case ButtonStatus.on:
            switch (buttonColorType) {
              case ButtonColorType.mono:
                switch (buttonStyleType) {
                  case ButtonStyleType.solid:
                    return Border.all(color: AppColor.primary4, width: 1);
                  case ButtonStyleType.line:
                    return Border.all(color: AppColor.gray300, width: 1);
                }
              case ButtonColorType.secondary:
                switch (buttonStyleType) {
                  case ButtonStyleType.solid:
                    return Border.all(color: AppColor.main, width: 1);
                  case ButtonStyleType.line:
                    return Border.all(color: AppColor.main, width: 1);
                }
            }
          case ButtonStatus.off:
            switch (buttonColorType) {
              case ButtonColorType.mono:
                switch (buttonStyleType) {
                  case ButtonStyleType.solid:
                    return Border.all(color: AppColor.gray300, width: 1);
                  case ButtonStyleType.line:
                    throw UnimplementedError();
                }
              case ButtonColorType.secondary:
                switch (buttonStyleType) {
                  case ButtonStyleType.solid:
                    throw UnimplementedError();
                  case ButtonStyleType.line:
                    return Border.all(color: AppColor.gray300, width: 1);
                }
            }
        }
    }
  }

  EdgeInsets get _padding {
    switch (buttonSize) {
      case ButtonSize.large:
        return EdgeInsets.symmetric(vertical: 16, horizontal: 24);
      case ButtonSize.medium:
        return EdgeInsets.symmetric(vertical: 11, horizontal: 20);
      case ButtonSize.small:
        return EdgeInsets.symmetric(vertical: 8, horizontal: 12);
      case ButtonSize.round:
        return EdgeInsets.symmetric(vertical: 6, horizontal: 10);
    }
  }

  double get _spacing {
    switch (buttonSize) {
      case ButtonSize.large:
        return 8.0;
      case ButtonSize.medium:
        return 6.0;
      case ButtonSize.small:
        return 4.0;
      case ButtonSize.round:
        return 2.0;
    }
  }

  TextStyle get _textStyle {
    switch (buttonSize) {
      case ButtonSize.large:
        return AppTypeface.subTitle4;
      case ButtonSize.medium:
        return AppTypeface.label2;
      case ButtonSize.small:
        return AppTypeface.caption2;
      case ButtonSize.round:
        return AppTypeface.caption3;
    }
  }

  Color get _color {
    switch (buttonSize) {
      case ButtonSize.large:
      case ButtonSize.medium:
      case ButtonSize.small:
        switch (buttonStatus) {
          case ButtonStatus.on:
            switch (buttonStyleType) {
              case ButtonStyleType.solid:
                return AppColor.gray00;
              case ButtonStyleType.line:
                return AppColor.primary5;
            }
          case ButtonStatus.off:
            switch (buttonStyleType) {
              case ButtonStyleType.solid:
                return AppColor.gray500;
              case ButtonStyleType.line:
                return AppColor.gray500;
            }
        }
      case ButtonSize.round:
        switch (buttonStatus) {
          case ButtonStatus.on:
            switch (buttonColorType) {
              case ButtonColorType.mono:
                switch (buttonStyleType) {
                  case ButtonStyleType.solid:
                    return AppColor.gray00;
                  case ButtonStyleType.line:
                    return AppColor.gray700;
                }
              case ButtonColorType.secondary:
                switch (buttonStyleType) {
                  case ButtonStyleType.solid:
                    return AppColor.gray00;
                  case ButtonStyleType.line:
                    return AppColor.main;
                }
            }
          case ButtonStatus.off:
            switch (buttonColorType) {
              case ButtonColorType.mono:
                switch (buttonStyleType) {
                  case ButtonStyleType.solid:
                    return AppColor.gray500;
                  case ButtonStyleType.line:
                    throw UnimplementedError();
                }
              case ButtonColorType.secondary:
                switch (buttonStyleType) {
                  case ButtonStyleType.solid:
                    throw UnimplementedError();
                  case ButtonStyleType.line:
                    return AppColor.gray500;
                }
            }
        }
    }
  }

  MainAxisSize get _mainAxisSize {
    switch (buttonSize) {
      case ButtonSize.large:
        return MainAxisSize.max;
      case ButtonSize.medium:
      case ButtonSize.small:
      case ButtonSize.round:
        return MainAxisSize.min;
    }
  }

  double get _iconSize {
    switch (buttonSize) {
      case ButtonSize.large:
        return 20.0;
      case ButtonSize.medium:
        return 16.0;
      case ButtonSize.small:
        return 12.0;
      case ButtonSize.round:
        return 12.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: buttonStatus == ButtonStatus.on ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: _padding,
        decoration: BoxDecoration(borderRadius: _borderRadius, color: _backgroundColor, border: _border),
        child: Row(
          spacing: _spacing,
          mainAxisSize: _mainAxisSize,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixIcon != null)
              prefixIcon!.svg(
                width: _iconSize,
                height: _iconSize,
                colorFilter: ColorFilter.mode(_color, BlendMode.srcIn),
              ),
            Text(text, style: _textStyle.copyWith(color: _color)),
            if (suffixIcon != null)
              suffixIcon!.svg(
                width: _iconSize,
                height: _iconSize,
                colorFilter: ColorFilter.mode(_color, BlendMode.srcIn),
              ),
          ],
        ),
      ),
    );
  }
}
