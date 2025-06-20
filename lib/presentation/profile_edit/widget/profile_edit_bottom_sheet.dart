import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/link.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';
import 'package:grimity/presentation/profile_edit/provider/upload_image_provider.dart';

void showBackgroundImageBottomSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
    ),
    builder: (context) {
      final uploadImage = ref.read(uploadImageProvider.notifier);

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(16),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                await uploadImage.deleteImage(UploadImageType.background);

                if (context.mounted) {
                  context.pop();
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                width: double.maxFinite,
                height: 42.w,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: Text("기본 커버로 변경", style: AppTypeface.label2),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                final isSelected = await uploadImage.pickImage(UploadImageType.background);

                if (isSelected && context.mounted) {
                  context.pop();
                  CropImageRoute().push(context);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                width: double.maxFinite,
                height: 42.w,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: Text("커버 변경", style: AppTypeface.label2),
              ),
            ),
            Gap(24),
            GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 11),
                width: double.maxFinite,
                height: 42.w,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.gray300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text("취소", style: AppTypeface.label2)),
              ),
            ),
            Gap(24),
          ],
        ),
      );
    },
  );
}

void showProfileImageBottomSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
    ),
    builder: (context) {
      final uploadImage = ref.read(uploadImageProvider.notifier);

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(16),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                await uploadImage.deleteImage(UploadImageType.profile);

                if (context.mounted) {
                  context.pop();
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                width: double.maxFinite,
                height: 42.w,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: Text("기본 프로필로 변경", style: AppTypeface.label2),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                final isSelected = await uploadImage.pickImage(UploadImageType.profile);

                if (isSelected && context.mounted) {
                  context.pop();
                  CropImageRoute().push(context);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                width: double.maxFinite,
                height: 42.w,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: Text("프로필 변경", style: AppTypeface.label2),
              ),
            ),
            Gap(24),
            GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 11),
                width: double.maxFinite,
                height: 42.w,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.gray300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text("취소", style: AppTypeface.label2)),
              ),
            ),
            Gap(24),
          ],
        ),
      );
    },
  );
}

showAddLinkBottomSheet(BuildContext context, ProfileEdit profileEditNotifier) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    constraints: BoxConstraints(maxHeight: 520.h),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(24),
            Row(
              children: [
                Text("외부 링크 선택", style: AppTypeface.subTitle3),
                const Spacer(),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Assets.icons.common.close.svg(width: 24, height: 24),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(16),
                    _BottomSheetButton(
                      height: 54.w,
                      child: Align(alignment: Alignment.centerLeft, child: Text("X", style: AppTypeface.label2)),
                      onTap: () {
                        profileEditNotifier.addLink(Link(linkName: "X", link: "https://x.com/"));
                        context.pop();
                      },
                    ),
                    Gap(8),
                    _BottomSheetButton(
                      height: 54.w,
                      child: Align(alignment: Alignment.centerLeft, child: Text("인스타그램", style: AppTypeface.label2)),
                      onTap: () {
                        profileEditNotifier.addLink(Link(linkName: "인스타그램", link: "https://www.instagram.com/"));
                        context.pop();
                      },
                    ),
                    Gap(8),
                    _BottomSheetButton(
                      height: 54.w,
                      child: Align(alignment: Alignment.centerLeft, child: Text("픽시브", style: AppTypeface.label2)),
                      onTap: () {
                        profileEditNotifier.addLink(Link(linkName: "픽시브", link: "https://www.pixiv.net/"));
                        context.pop();
                      },
                    ),
                    Gap(8),
                    _BottomSheetButton(
                      height: 54.w,
                      child: Align(alignment: Alignment.centerLeft, child: Text("유튜브", style: AppTypeface.label2)),
                      onTap: () {
                        profileEditNotifier.addLink(Link(linkName: "유튜브", link: "https://www.youtube.com/"));
                        context.pop();
                      },
                    ),
                    Gap(8),
                    _BottomSheetButton(
                      height: 54.w,
                      child: Align(alignment: Alignment.centerLeft, child: Text("이메일", style: AppTypeface.label2)),
                      onTap: () {
                        profileEditNotifier.addLink(Link(linkName: "이메일", link: ""));
                        context.pop();
                      },
                    ),
                    Gap(8),
                    _BottomSheetButton(
                      height: 54.w,
                      child: Align(alignment: Alignment.centerLeft, child: Text("웹", style: AppTypeface.label2)),
                      onTap: () {
                        profileEditNotifier.addLink(Link(linkName: "", link: "https://"));
                        context.pop();
                      },
                    ),
                    Gap(24),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
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
