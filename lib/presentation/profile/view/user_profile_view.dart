import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_placeholder.dart';
import 'package:grimity/presentation/profile/widget/profile_bottom_sheet.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrimityProfileBackgroundImage(url: user.backgroundImage),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              _UserProfile(user: user),
              _buildProfileImage(),
              _buildEditButton(context),
              _buildMoreButton(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    return Positioned.fill(
      top: -40,
      child: Align(alignment: Alignment.topLeft, child: GrimityProfileImage(url: user.image)),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return Positioned.fill(
      top: 5,
      left: 53,
      child: Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
          onTap: () => context.push(ProfileEditRoute.path, extra: user),
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withValues(alpha: 0.5),
            ),
            child: Center(child: Assets.icons.profile.edit.svg(width: 16, height: 16)),
          ),
        ),
      ),
    );
  }

  Widget _buildMoreButton(BuildContext context) {
    return Positioned.fill(
      top: 14,
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => showProfileMoreBottomSheet(context, user.url),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.gray300, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Assets.icons.profile.moreHoriz.svg(width: 20, height: 20)),
          ),
        ),
      ),
    );
  }
}

class _UserProfile extends StatelessWidget {
  const _UserProfile({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(40),
        _buildUserName(),
        Gap(2),
        _buildUserFollowerCount(),
        _buildUserDescription(),
        _buildUserLinks(context),
        Gap(16),
      ],
    );
  }

  Widget _buildUserName() {
    if (user.id == '') {
      return Skeletonizer(enabled: true, child: Text(user.name, style: AppTypeface.subTitle1));
    }

    return Text(user.name, style: AppTypeface.subTitle1);
  }

  Widget _buildUserFollowerCount() {
    return Row(
      children: [
        Text('팔로워', style: AppTypeface.label3.copyWith(color: AppColor.gray600)),
        Gap(4),
        Text(user.followerCount.toString(), style: AppTypeface.label2.copyWith(color: AppColor.gray700)),
        Gap(8),
        Text('팔로잉', style: AppTypeface.label3.copyWith(color: AppColor.gray600)),
        Gap(4),
        Text(user.followingCount.toString(), style: AppTypeface.label2.copyWith(color: AppColor.gray700)),
      ],
    );
  }

  Widget _buildUserDescription() {
    if (user.description != null && user.description!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(8),
          Text(
            user.description!,
            style: AppTypeface.label2.copyWith(color: AppColor.gray700),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildUserLinks(BuildContext context) {
    if (user.links == null || user.links!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(12),
        ...user.links!.mapIndexed((index, e) {
          if (index > 2) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: EdgeInsets.only(bottom: index < 2 ? 6 : 0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async => await launchUrl(Uri.parse(e.link)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (e.linkName == 'X') ...[
                    Assets.icons.profile.x.image(width: 18, height: 18),
                  ] else if (e.linkName == '인스타그램') ...[
                    Assets.icons.profile.instagram.image(width: 18, height: 18),
                  ] else if (e.linkName == '픽시브') ...[
                    Assets.icons.profile.pixiv.image(width: 18, height: 18),
                  ] else if (e.linkName == '유튜브') ...[
                    Assets.icons.profile.youtube.image(width: 18, height: 18),
                  ] else if (e.linkName == '이메일') ...[
                    Assets.icons.profile.mail.image(width: 18, height: 18),
                  ] else ...[
                    Assets.icons.profile.web.image(width: 18, height: 18),
                  ],
                  Gap(4),
                  Row(
                    children: [
                      Text('@${e.link.split('/').last}', style: AppTypeface.caption1.copyWith(color: AppColor.gray700)),
                      if (index == 2 && user.links!.length > 3) ...[
                        Gap(12),
                        GestureDetector(
                          onTap: () => showProfileLinkBottomSheet(context, user.links!),
                          child: Text(
                            '외 링크 ${user.links!.length - 3}개',
                            style: AppTypeface.caption1.copyWith(color: AppColor.main),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
