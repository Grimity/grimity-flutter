import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_config.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/app/enum/report.enum.dart';
import 'package:grimity/data/data_source/remote/chat_api.dart';
import 'package:grimity/domain/dto/chat_request_params.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/alert/grimity_dialog.dart';
import 'package:grimity/presentation/common/widget/button/grimity_follow_button.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_modal_bottom_sheet.dart';
import 'package:grimity/presentation/common/widget/system/more/grimity_more_button.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_share_modal_bottom_sheet.dart';
import 'package:grimity/presentation/common/widget/system/profile/grimity_profile_background_image.dart';
import 'package:grimity/presentation/common/widget/system/profile/grimity_profile_image.dart';
import 'package:grimity/presentation/profile/enum/link_type_enum.dart';
import 'package:grimity/presentation/profile/enum/profile_view_type_enum.dart';
import 'package:grimity/presentation/profile/provider/profile_data_provider.dart';
import 'package:grimity/presentation/profile/provider/profile_view_type_argument_provider.dart';
import 'package:grimity/presentation/profile/widget/profile_bottom_sheet.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileView extends ConsumerWidget {
  const UserProfileView({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewType = ref.watch(profileViewTypeArgumentProvider);

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
              _buildButtons(context, ref, viewType),
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
        child: GrimityGesture(
          onTap: () => context.push(ProfileEditRoute.path, extra: user),
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withValues(alpha: 0.5),
            ),
            child: Center(child: Assets.icons.icon.edit.svg(width: 16, height: 16)),
          ),
        ),
      ),
    );
  }

  // 팔로잉/언팔로우 버튼, 더보기 버튼
  Widget _buildButtons(BuildContext context, WidgetRef ref, ProfileViewType viewType) {
    return Positioned.fill(
      top: 14,
      child: Align(
        alignment: Alignment.topRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (viewType == ProfileViewType.other && user.isBlocking == false && user.isBlocked == false) ...[
              GrimityFollowButton(url: user.url),
              Gap(10),
            ],
            GrimityMoreButton.decorated(onTap: () => _showMoreBottomSheet(context, ref, viewType)),
          ],
        ),
      ),
    );
  }

  void _showMoreBottomSheet(BuildContext context, WidgetRef ref, ProfileViewType viewType) {
    final List<GrimityModalButtonModel> buttons = [
      GrimityModalButtonModel(
        title: '프로필 링크 공유',
        onTap: () {
          context.pop();
          GrimityShareModalBottomSheet.show(
            context,
            url: AppConfig.buildUserUrl(user.url),
            shareContentType: ShareContentType.profile,
            nickname: user.name,
            description: user.name,
            imageUrl: user.image,
          );
        },
      ),
      if (viewType == ProfileViewType.mine) ...[
        GrimityModalButtonModel(
          title: '회원 탈퇴',
          onTap: () {
            context.pop();
            showDeleteAccountDialog(context, ref);
          },
        ),
        GrimityModalButtonModel(
          title: '차단 목록',
          onTap: () {
            context.pop();
            BlockedUsersRoute().push(context);
          },
        ),
      ] else ...[
        if (user.isBlocking == false && user.isBlocked == false)
          GrimityModalButtonModel(
            title: '메세지 보내기',
            onTap: () async {
              context.pop();

              final request = CreateChatRequest(targetUserId: user.id);
              final response = await getIt<ChatAPI>().createChat(request);

              if (context.mounted) {
                ChatMessageRoute(response.id).push(context);
              }
            },
          ),
        GrimityModalButtonModel.report(context: context, refType: ReportRefType.user, refId: user.id),
        user.isBlocking == true
            ? GrimityModalButtonModel(
              title: '차단 해제',
              onTap: () async {
                context.pop();
                ref.read(profileDataProvider(user.url).notifier).unblockUser(user.id);
              },
            )
            : GrimityModalButtonModel(
              title: '차단하기',
              onTap: () async {
                context.pop();
                ref.read(profileDataProvider(user.url).notifier).blockUser(user.id);
              },
            ),
      ],
    ];
    GrimityModalBottomSheet.show(context, buttons: buttons);
  }

  void showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (builderContext) => GrimityDialog(
            title: '정말 탈퇴하시겠어요?',
            content: '계정 복구는 어려워요.',
            cancelText: '취소',
            confirmText: '탈퇴하기',
            onCancel: () => builderContext.pop(),
            onConfirm: () async {
              final user = ref.read(userAuthProvider);
              if (user == null) return;

              builderContext.pop();
              await completeDeleteUserProcessUseCase.execute(LoginProvider.fromString(user.provider ?? ''));
              if (context.mounted) {
                SignInRoute().go(context);
              }
            },
          ),
    );
  }
}

class _UserProfile extends ConsumerWidget {
  const _UserProfile({required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewType = ref.watch(profileViewTypeArgumentProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(40),
        _buildUserName(),
        Gap(2),
        _buildUserFollowerCount(context, viewType),
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

  Widget _buildUserFollowerCount(BuildContext context, ProfileViewType viewType) {
    return GrimityGesture(
      onTap: viewType == ProfileViewType.mine ? () => FollowRoute().push(context) : null,
      child: Row(
        children: [
          Text('팔로워', style: AppTypeface.label3.copyWith(color: AppColor.gray600)),
          Gap(4),
          Text(user.followerCount.toString(), style: AppTypeface.label2.copyWith(color: AppColor.gray700)),
          // 내 프로필의 경우에만 팔로잉 표시
          if (viewType == ProfileViewType.mine) ...[
            Gap(8),
            Text('팔로잉', style: AppTypeface.label3.copyWith(color: AppColor.gray600)),
            Gap(4),
            Text(user.followingCount.toString(), style: AppTypeface.label2.copyWith(color: AppColor.gray700)),
          ],
        ],
      ),
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
            child: GrimityGesture(
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
                            LinkType.displayLink(e),
                            style: AppTypeface.caption1.copyWith(color: AppColor.gray700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (index == 2 && user.links!.length > 3) ...[
                          Gap(12),
                          GrimityGesture(
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
