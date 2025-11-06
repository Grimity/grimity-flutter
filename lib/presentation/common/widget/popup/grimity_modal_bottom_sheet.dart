import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/enum/report.enum.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';

class GrimityModalBottomSheet extends StatelessWidget {
  final List<GrimityModalButtonModel> buttons;

  const GrimityModalBottomSheet({super.key, required this.buttons});

  static void show(BuildContext context, {required List<GrimityModalButtonModel> buttons}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      builder: (context) => GrimityModalBottomSheet(buttons: buttons),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...buttons.map(
            (button) => GrimityGesture(
              onTap: button.onTap,
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Text(button.title, style: AppTypeface.label2),
              ),
            ),
          ),
          Gap(24),
          _BottomSheetButton(
            onTap: () {
              context.pop();
            },
            child: Center(child: Text('취소', style: AppTypeface.label2)),
          ),
        ],
      ),
    );
  }
}

class GrimityModalButtonModel {
  final String title;
  final VoidCallback onTap;

  GrimityModalButtonModel({required this.title, required this.onTap});

  factory GrimityModalButtonModel.report({
    required BuildContext context,
    required ReportRefType refType,
    required String refId,
  }) => GrimityModalButtonModel(
    title: '신고하기',
    onTap: () {
      context.pop();
      ReportRoute(refType: refType, refId: refId).push(context);
    },
  );
}

class _BottomSheetButton extends StatelessWidget {
  const _BottomSheetButton({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GrimityGesture(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
        width: double.maxFinite,
        height: 42.w,
        decoration: BoxDecoration(border: Border.all(color: AppColor.gray300), borderRadius: BorderRadius.circular(12)),
        child: child,
      ),
    );
  }
}
