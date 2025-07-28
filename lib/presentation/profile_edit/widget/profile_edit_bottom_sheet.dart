import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/link.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/profile/enum/link_type_enum.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';

/// TODO 공통화 외부 링크 선택
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
            Gap(16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children:
                      LinkType.values
                          .map(
                            (e) => _BottomSheetButton(
                              height: 54.w,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(e.linkName, style: AppTypeface.label2),
                              ),
                              onTap: () {
                                profileEditNotifier.addLink(Link(linkName: e.linkName, link: e.defaultLink));
                                context.pop();
                              },
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
            Gap(24),
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
