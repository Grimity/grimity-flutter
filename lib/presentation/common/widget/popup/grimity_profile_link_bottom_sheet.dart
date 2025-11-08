import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/link.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/profile/enum/link_type_enum.dart';
import 'package:url_launcher/url_launcher.dart';

/// 프로필 링크 공유 바텀 시트
class GrimityProfileLinkBottomSheet extends StatelessWidget {
  const GrimityProfileLinkBottomSheet({super.key, required this.links});

  final List<Link> links;

  static void show(BuildContext context, {required List<Link> links}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      constraints: BoxConstraints(maxHeight: 520.h),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      builder: (context) => GrimityProfileLinkBottomSheet(links: links),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 24 + MediaQuery.of(context).padding.bottom, top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text("프로필 링크", style: AppTypeface.subTitle3),
              const Spacer(),
              GrimityGesture(onTap: () => context.pop(), child: Assets.icons.common.close.svg(width: 24, height: 24)),
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
        ],
      ),
    );
  }
}

class _LinkItem extends StatelessWidget {
  const _LinkItem({required this.link});

  final Link link;

  @override
  Widget build(BuildContext context) {
    return GrimityGesture(
      onTap: () async {
        if (link.linkName == '이메일') {
          await launchUrl(Uri.parse('mailto:${link.link}'));
        } else {
          await launchUrl(Uri.parse(link.link));
        }
      },
      child: Row(
        children: [
          LinkType.getLinkImage(link.linkName, 28, 28),
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
