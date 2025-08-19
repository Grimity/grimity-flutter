import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';

/// 공통 선택 모달 바텀 시트
class GrimitySelectModalBottomSheet extends StatelessWidget {
  final String title;
  final List<GrimitySelectModalButtonModel> buttons;

  const GrimitySelectModalBottomSheet({super.key, required this.title, required this.buttons});

  static void show(
    BuildContext context, {
    required String title,
    required List<GrimitySelectModalButtonModel> buttons,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      constraints: BoxConstraints(maxHeight: 520.h),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      builder: (context) => GrimitySelectModalBottomSheet(title: title, buttons: buttons),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(24),
          Row(
            children: [
              Text(title, style: AppTypeface.subTitle3),
              const Spacer(),
              GestureDetector(onTap: () => context.pop(), child: Assets.icons.common.close.svg(width: 24, height: 24)),
            ],
          ),
          Gap(24),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children:
                  buttons
                      .map(
                        (e) => _SelectBottomSheetButton(
                          title: e.title,
                          onTap: e.onTap,
                          isSelected: e.isSelected,
                          isDisabled: e.isDisabled,
                        ),
                      )
                      .toList(),
            ),
          ),
          Gap(24),
        ],
      ),
    );
  }
}

class GrimitySelectModalButtonModel {
  final String title;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isDisabled;

  GrimitySelectModalButtonModel({required this.title, this.onTap, this.isSelected = false, this.isDisabled = false});
}

class _SelectBottomSheetButton extends StatelessWidget {
  const _SelectBottomSheetButton({
    required this.title,
    required this.onTap,
    this.isSelected = false,
    this.isDisabled = false,
  });

  final String title;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isDisabled;

  Color get _borderColor =>
      isDisabled
          ? AppColor.gray300
          : isSelected
          ? AppColor.main
          : AppColor.gray300;

  Color get _boxColor =>
      isDisabled
          ? AppColor.gray200
          : isSelected
          ? AppColor.mainSecondary
          : AppColor.gray00;

  Color get _textColor => isDisabled ? AppColor.gray500 : AppColor.gray800;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        height: 52,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor),
          color: _boxColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTypeface.label2.copyWith(color: _textColor)),
            if (isSelected) Assets.icons.common.checkMark.svg(),
          ],
        ),
      ),
    );
  }
}
