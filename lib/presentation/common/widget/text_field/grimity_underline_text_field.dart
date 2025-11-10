import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/enum/grimity.enum.dart';
import 'package:grimity/gen/assets.gen.dart';

class GrimityUnderlineTextField extends HookWidget {
  const GrimityUnderlineTextField.normal({
    super.key,
    this.state = GrimityTextFieldState.normal,
    this.enabled = true,
    this.useBodyTextStyle = false,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.autoFocus,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.hintText,
    this.errorText,
  }) : type = GrimityTextFieldType.normal;

  const GrimityUnderlineTextField.small({
    super.key,
    this.state = GrimityTextFieldState.normal,
    this.enabled = true,
    this.useBodyTextStyle = false,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.autoFocus,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.hintText,
    this.errorText,
  }) : type = GrimityTextFieldType.small;

  final GrimityTextFieldType type;
  final GrimityTextFieldState state;

  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final bool? autoFocus;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final bool enabled;
  final int? maxLength;
  final String? hintText;
  final String? errorText;
  final void Function(String)? onSubmitted;

  final bool useBodyTextStyle;

  Color get _fillColor {
    if (!enabled) return AppColor.gray100;
    switch (state) {
      case GrimityTextFieldState.error:
        return AppColor.statusNegative.withValues(alpha: 0.1);
      case GrimityTextFieldState.success:
        return AppColor.mainSecondary;
      default:
        return AppColor.gray00;
    }
  }

  Color get _borderColor {
    switch (state) {
      case GrimityTextFieldState.error:
        return AppColor.statusNegative;
      case GrimityTextFieldState.success:
        return AppColor.main;
      default:
        return AppColor.gray300;
    }
  }

  Color get _enabledBorderColor {
    switch (state) {
      case GrimityTextFieldState.error:
        return AppColor.statusNegative;
      case GrimityTextFieldState.success:
        return AppColor.main;
      default:
        return AppColor.gray700;
    }
  }

  Widget? get _suffixWidget {
    if (state == GrimityTextFieldState.success) {
      return Assets.icons.common.checkMark.svg();
    } else if (maxLength != null && focusNode?.hasFocus == true) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('${controller?.text.length ?? 0}', style: AppTypeface.caption2),
          Text('/$maxLength', style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
        ],
      );
    }
    return null;
  }

  TextStyle get _textStyle {
    if (useBodyTextStyle) {
      return AppTypeface.body1;
    } else {
      return AppTypeface.label2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController();

    final textField = TextField(
          enabled: enabled,
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: _textStyle,
          maxLength: maxLength,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            counterText: '',
            hintText: hintText,
            hintStyle: _textStyle.copyWith(color: AppColor.gray500),
            border: UnderlineInputBorder(borderSide: BorderSide(color: _enabledBorderColor)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _enabledBorderColor)),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _borderColor)),
            disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _borderColor)),
            filled: true,
            fillColor: _fillColor,
            suffixIconConstraints: const BoxConstraints(minWidth: 18, minHeight: 18),
            suffixIcon:
                _suffixWidget != null ? Padding(padding: const EdgeInsets.only(right: 16), child: _suffixWidget) : null,
          ),
        )
        .animate(
          autoPlay: false,
          controller: animationController,
          onComplete: (controller) => controller.repeat(reverse: true, count: 1),
        )
        .shakeX(amount: 5, duration: 300.ms, curve: Curves.easeInOut);

    useEffect(() {
      if (state == GrimityTextFieldState.error) {
        animationController.reset();
        animationController.forward();
      }
      return null;
    }, [state]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textField,
        if (state == GrimityTextFieldState.error && errorText != null) ...[
          const Gap(6),
          Text(errorText!, style: AppTypeface.caption2.copyWith(color: AppColor.statusNegative)),
        ],
      ],
    );
  }
}
