import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_follow_button.dart';
import 'package:grimity/presentation/common/widget/grimity_modal_bottom_sheet.dart';
import 'package:grimity/presentation/common/widget/grimity_more_button.dart';
import 'package:grimity/presentation/common/widget/grimity_placeholder.dart';
import 'package:grimity/presentation/common/widget/grimity_share_modal_bottom_sheet.dart';
import 'package:grimity/presentation/profile/enum/link_type_enum.dart';
import 'package:grimity/presentation/profile/enum/profile_view_type_enum.dart';
import 'package:grimity/presentation/profile/widget/profile_bottom_sheet.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key, required this.user, required this.viewType});

  final User user;
  final ProfileViewType viewType;

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
              if (viewType == ProfileViewType.mine) _buildEditButton(context),
              _buildButtons(context),
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

  // 팔로잉/언팔로우 버튼, 더보기 버튼
  Widget _buildButtons(BuildContext context) {
    return Positioned.fill(
      top: 14,
      child: Align(
        alignment: Alignment.topRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (viewType == ProfileViewType.other) ...[
              GrimityFollowButton(
                url: user.url,
              ),
              Gap(10.w),
            ],
            GrimityMoreButton(onTap: () => _showMoreBottomSheet(context)),
          ],
        ),
      ),
    );
  }

  void _showMoreBottomSheet(BuildContext context) {
    final List<GrimityModalButtonModel> buttons = [
      GrimityModalButtonModel(
        title: '프로필 링크 공유',
        onTap: () {
          context.pop();
          GrimityShareModalBottomSheet.show(context, url: user.url);
        },
      ),
      if (viewType == ProfileViewType.mine) ...[
        GrimityModalButtonModel(
          title: '회원 탈퇴',
          onTap: () {
            context.pop();
          },
        ),
      ] else ...[
        GrimityModalButtonModel(
          title: '메세지 보내기',
          onTap: () {
            context.pop();
          },
        ),
        GrimityModalButtonModel(
          title: '신고하기',
          onTap: () {
            context.pop();
          },
        ),
      ],
    ];
    GrimityModalBottomSheet.show(context, buttons: buttons);
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
                  LinkType.getLinkImage(e.linkName, 18, 18),
                  Gap(4),
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            LinkType.isCustomLinkType(e.linkName) ? e.linkName : e.link.split('/').last,
                            style: AppTypeface.caption1.copyWith(color: AppColor.gray700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
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
