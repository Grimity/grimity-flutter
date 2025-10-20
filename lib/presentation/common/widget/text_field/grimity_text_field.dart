import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/enum/grimity.enum.dart';
import 'package:grimity/gen/assets.gen.dart';

class GrimityTextField extends HookWidget {
  const GrimityTextField.normal({
    super.key,
    this.state = GrimityTextFieldState.normal,
    this.enabled = true,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onEdit,
    this.onCancel,
    this.onSave,
    this.autoFocus,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.maxLines,
    this.hintText,
    this.errorText,
    this.defaultText,
    this.showSuffix = true,
    this.showSearchIcon = false,
    this.onSearch,
  }) : type = GrimityTextFieldType.normal;

  const GrimityTextField.small({
    super.key,
    this.state = GrimityTextFieldState.normal,
    this.enabled = true,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onEdit,
    this.onCancel,
    this.onSave,
    this.autoFocus,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.maxLines,
    this.hintText,
    this.errorText,
    this.defaultText,
    this.showSuffix = true,
    this.showSearchIcon = false,
    this.onSearch,
  }) : type = GrimityTextFieldType.small;

  const GrimityTextField.borderless({
    super.key,
    this.state = GrimityTextFieldState.normal,
    this.enabled = true,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onEdit,
    this.onCancel,
    this.onSave,
    this.autoFocus,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.maxLines,
    this.hintText,
    this.errorText,
    this.defaultText,
    this.showSuffix = true,
    this.showSearchIcon = false,
    this.onSearch,
  }) : type = GrimityTextFieldType.borderless;

  final GrimityTextFieldType type;
  final GrimityTextFieldState state;

  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  final void Function()? onEdit;
  final void Function()? onCancel;
  final void Function()? onSave;

  final bool? autoFocus;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final bool enabled;
  final int? maxLength;
  final int? maxLines;
  final String? hintText;
  final String? errorText;
  final String? defaultText;

  final bool showSuffix;

  final bool showSearchIcon;
  final void Function()? onSearch;

  BorderRadius get _borderRadius =>
      type == GrimityTextFieldType.normal ? BorderRadius.circular(12) : BorderRadius.circular(8);

  EdgeInsets get _contentPadding {
    if (type == GrimityTextFieldType.borderless) {
      return EdgeInsets.symmetric(vertical: 16);
    }

    return type == GrimityTextFieldType.normal
        ? const EdgeInsets.all(16)
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
  }

  Color get _fillColor {
    if (type == GrimityTextFieldType.borderless) {
      return Colors.transparent;
    }

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
      case GrimityTextFieldState.disabled:
        return AppColor.primary4;
      default:
        return AppColor.gray700;
    }
  }

  Widget? get _suffixWidget {
    if (showSuffix == false) {
      return null;
    }

    if (state == GrimityTextFieldState.success) {
      return Assets.icons.common.checkMark.svg();
    } else if (state == GrimityTextFieldState.disabled) {
      if (enabled == false) {
        return GestureDetector(
          onTap: onEdit,
          child: Text('수정', style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
        );
      } else {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: onCancel,
              child: Text('취소', style: AppTypeface.caption2.copyWith(color: AppColor.gray700)),
            ),
            Gap(24),
            GestureDetector(
              onTap: onSave,
              child: Text('완료', style: AppTypeface.caption2.copyWith(color: AppColor.main)),
            ),
          ],
        );
      }
    } else if (maxLength != null) {
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

  Widget? get _suffixIcon {
    if (showSearchIcon) {
      return IconButton(
        onPressed: onSearch,
        icon: Assets.icons.common.search.svg(
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(AppColor.gray600, BlendMode.srcIn),
        ),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController();
    final focusNode = this.focusNode ?? useFocusNode();
    final isBorderless = type == GrimityTextFieldType.borderless;

    final textField = TextField(
          enabled: enabled,
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: AppTypeface.label2,
          maxLength: maxLength,
          decoration: InputDecoration(
            contentPadding: _contentPadding,
            counterText: '',
            hintText: hintText,
            hintStyle: AppTypeface.label2.copyWith(color: AppColor.gray500),
            border: isBorderless ? InputBorder.none : OutlineInputBorder(
              borderSide: BorderSide(color: _enabledBorderColor),
              borderRadius: _borderRadius,
            ),
            focusedBorder: isBorderless ? InputBorder.none : OutlineInputBorder(
              borderSide: BorderSide(color: _enabledBorderColor),
              borderRadius: _borderRadius,
            ),
            enabledBorder: isBorderless ? InputBorder.none : OutlineInputBorder(borderSide: BorderSide(color: _borderColor), borderRadius: _borderRadius),
            disabledBorder: isBorderless ? InputBorder.none : OutlineInputBorder(
              borderSide: BorderSide(color: _borderColor),
              borderRadius: _borderRadius,
            ),
            filled: true,
            fillColor: _fillColor,
            prefix:
                defaultText != null
                    ? Text(defaultText!, style: AppTypeface.label2.copyWith(color: AppColor.gray500))
                    : null,
            suffixIconConstraints: const BoxConstraints(minWidth: 18, minHeight: 18),
            suffixIcon: _suffixIcon,
          ),
          maxLines: maxLines,
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
        Stack(
          children: [textField, if (_suffixWidget != null) Positioned(right: 16, bottom: 16, child: _suffixWidget!)],
        ),
        if (state == GrimityTextFieldState.error && errorText != null) ...[
          const Gap(6),
          Text(errorText!, style: AppTypeface.caption2.copyWith(color: AppColor.statusNegative)),
        ],
      ],
    );
  }
}
