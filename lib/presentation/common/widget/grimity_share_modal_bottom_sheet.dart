import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/gen/assets.gen.dart';

/// 링크 공유 모달 바텀 시트
class GrimityShareModalBottomSheet extends StatelessWidget {
  const GrimityShareModalBottomSheet({super.key, required this.url});

  final String url;

  static void show(BuildContext context, {required String url}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      builder: (context) => GrimityShareModalBottomSheet(url: url,),
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
              Text("게시글 공유하기", style: AppTypeface.subTitle3),
              const Spacer(),
              GestureDetector(
                onTap: () => context.pop(),
                child: Assets.icons.common.close.svg(width: 24, height: 24),
              ),
            ],
          ),
          Gap(16),
          _BottomSheetButton(
            height: 54.w,
            child: Row(
              children: [
                Assets.icons.profile.link.svg(width: 24, height: 24),
                Gap(8),
                Text("링크 복사하기", style: AppTypeface.label2),
              ],
            ),
            onTap: () {
              Clipboard.setData(ClipboardData(text: url));
              ToastService.show('링크가 복사되었어요.');
              context.pop();
            },
          ),
          Gap(16),
          _BottomSheetButton(
            height: 54.w,
            onTap: () {
              // TODO X 공유
            },
            child: Row(
              children: [
                Assets.icons.profile.xOutlined.image(width: 24, height: 24),
                Gap(8),
                Text("X로 공유", style: AppTypeface.label2),
              ],
            ),
          ),
          Gap(16),
          _BottomSheetButton(
            height: 54.w,
            onTap: () {
              // TODO 카카오톡 공유
            },
            child: Row(
              children: [
                Assets.icons.profile.kakaotalk.image(width: 24, height: 24),
                Gap(8),
                Text("카카오톡으로 공유", style: AppTypeface.label2),
              ],
            ),
          ),
          Gap(24),
        ],
      ),
    );
  }
}

class _BottomSheetButton extends StatelessWidget {
  const _BottomSheetButton({required this.child, required this.onTap, this.height});

  final Widget child;
  final VoidCallback onTap;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
        width: double.maxFinite,
        height: height ?? 42.w,
        decoration: BoxDecoration(border: Border.all(color: AppColor.gray300), borderRadius: BorderRadius.circular(12)),
        child: child,
      ),
    );
  }
}
