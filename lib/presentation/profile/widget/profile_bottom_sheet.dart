import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/link.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:url_launcher/url_launcher.dart';

void showProfileMoreBottomSheet(BuildContext context, String url) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(16),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                context.pop();
                showProfileShareBottomSheet(context, url);
              },
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Text("프로필 링크 공유", style: AppTypeface.label2),
              ),
            ),
            Gap(16),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                context.pop();
              },
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Text("회원 탈퇴", style: AppTypeface.label2),
              ),
            ),
            Gap(24),
            _BottomSheetButton(
              onTap: () {
                context.pop();
              },
              child: Center(child: Text("취소", style: AppTypeface.label2)),
            ),
          ],
        ),
      );
    },
  );
}

void showProfileShareBottomSheet(BuildContext context, String url) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
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
                Text("프로필 공유하기", style: AppTypeface.subTitle3),
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
                context.pop();
              },
            ),
            Gap(16),
            _BottomSheetButton(
              height: 54.w,
              onTap: () {},
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
              onTap: () {},
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
    },
  );
}

void showProfileLinkBottomSheet(BuildContext context, List<Link> links) {
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
                Text("프로필 링크", style: AppTypeface.subTitle3),
                const Spacer(),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Assets.icons.common.close.svg(width: 24, height: 24),
                ),
              ],
            ),
            Gap(24),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: links.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: index == links.length - 1 ? 0 : 16),
                    child: _LinkItem(link: links[index]),
                  );
                },
              ),
            ),
            Gap(24),
          ],
        ),
      );
    },
  );
}

class _LinkItem extends StatelessWidget {
  const _LinkItem({required this.link});

  final Link link;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        if (link.linkName == '이메일') {
          await launchUrl(Uri.parse('mailto:${link.link}'));
        } else {
          await launchUrl(Uri.parse(link.link));
        }
      },
      child: Row(
        children: [
          if (link.linkName == 'X') ...[
            Assets.icons.profile.x.image(width: 28, height: 28),
          ] else if (link.linkName == '인스타그램') ...[
            Assets.icons.profile.instagram.image(width: 28, height: 28),
          ] else if (link.linkName == '픽시브') ...[
            Assets.icons.profile.pixiv.image(width: 28, height: 28),
          ] else if (link.linkName == '유튜브') ...[
            Assets.icons.profile.youtube.image(width: 28, height: 28),
          ] else if (link.linkName == '이메일') ...[
            Assets.icons.profile.mail.image(width: 28, height: 28),
          ] else ...[
            Assets.icons.profile.web.image(width: 28, height: 28),
          ],
          Gap(14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(link.linkName, style: AppTypeface.label1),
              Text(link.link, style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
            ],
          ),
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
