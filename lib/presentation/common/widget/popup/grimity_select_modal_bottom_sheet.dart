import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 공통 선택 모달 바텀 시트
class GrimitySelectModalBottomSheet extends ConsumerWidget {
  final String? title;
  final Widget? titleWidget;
  final List<GrimitySelectModalButtonModel>? buttons;
  final List<GrimitySelectModalButtonModel> Function(WidgetRef ref)? buttonsBuilder;
  final VoidCallback? onSave;

  const GrimitySelectModalBottomSheet({
    super.key,
    required this.title,
    required this.titleWidget,
    this.buttons,
    this.buttonsBuilder,
    this.onSave,
  }) : assert(title != null || titleWidget != null, 'Either buttons or buttonsBuilder must be provided'),
       assert(buttons != null || buttonsBuilder != null, 'Either buttons or buttonsBuilder must be provided');

  static void show(
    BuildContext context, {
    String? title,
    Widget? titleWidget,
    List<GrimitySelectModalButtonModel>? buttons,
    List<GrimitySelectModalButtonModel> Function(WidgetRef ref)? buttonsBuilder,
    VoidCallback? onSave,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      constraints: BoxConstraints(maxHeight: 520.h),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      builder: (modalContext) {
        final container = ProviderScope.containerOf(context, listen: false);
        return UncontrolledProviderScope(
          container: container,
          child: GrimitySelectModalBottomSheet(
            title: title,
            titleWidget: titleWidget,
            buttons: buttons,
            buttonsBuilder: buttonsBuilder,
            onSave: onSave,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleNode = titleWidget ?? Text(title!, style: AppTypeface.subTitle3);
    final models = buttons ?? buttonsBuilder?.call(ref) ?? [];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(24),
          Row(
            children: [
              titleNode,
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
                  models
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
          if (onSave != null) ...[
            GestureDetector(
              onTap: onSave,
              child: Container(
                decoration: BoxDecoration(color: AppColor.primary4, borderRadius: BorderRadius.circular(10)),
                height: 42,
                child: Center(child: Text('저장', style: AppTypeface.label2.copyWith(color: AppColor.gray00))),
              ),
            ),
            Gap(24),
          ],
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
