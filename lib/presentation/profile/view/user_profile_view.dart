import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_config.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/app/enum/report.enum.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/data/gen/models/create_chat_request.dart';
import 'package:grimity/data/gen/rest_client.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:grimity/presentation/block/widget/blocked_users_modal.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_menu_popup.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_share_popup.dart';
import 'package:grimity/presentation/common/widget/system/profile/grimity_profile_background_image.dart';
import 'package:grimity/presentation/follow/follow_page.dart';
import 'package:grimity/presentation/profile/enum/link_type_enum.dart';
import 'package:grimity/presentation/profile/enum/profile_view_type_enum.dart';
import 'package:grimity/presentation/profile/provider/profile_data_provider.dart';
import 'package:grimity/presentation/profile/provider/profile_view_type_argument_provider.dart';
import 'package:grimity/presentation/profile/widget/profile_link_popup.dart';
import 'package:grimity/presentation/profile_edit/profile_edit_page.dart';
import 'package:grimity/presentation/report/report_page.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileView extends ConsumerWidget {
  const UserProfileView({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewType = ref.watch(profileViewTypeArgumentProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: context.isMobile ? GdsSpacing.spacing12 : GdsSpacing.spacing24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GrimityProfileBackgroundImage(
            url: user.backgroundImage,
            isMine: viewType == ProfileViewType.mine,
          ),
          _UserProfile(user: user),
        ],
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
    final isMine = viewType == ProfileViewType.mine;
    final colors = context.gdsColors;

    if (context.isMobile) {
      return Padding(
        padding: EdgeInsets.only(
          top: GdsSpacing.spacing16,
          left: GdsSpacing.spacing16,
          right: GdsSpacing.spacing16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: GdsSpacing.spacing12,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildProfile(context, viewType),
                _buildActions(context, ref, viewType),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: GdsSpacing.spacing8,
              children: [
                Text(user.name, style: GdsTypography.title2.copyWith(color: colors.text.grayBold)),
                GdsUserInfo.follow(
                  followerCount: user.followerCount ?? 0,
                  followingCount: user.followingCount ?? 0,
                  onFollowerTap: isMine ? () => FollowPage.push(context, 1) : null,
                  onFollowingTap: isMine ? () => FollowPage.push(context, 0) : null,
                ),
              ],
            ),

            // 사용자에 대한 설명 표시
            if (user.description?.isNotEmpty ?? false) ...[
              Text(
                user.description ?? '',
                style: GdsTypography.label6.copyWith(color: colors.text.grayBold),
              ),
            ],

            // 사용자에 대한 링크 표시
            if (user.links?.isNotEmpty ?? false) _buildLinkWrap(context),
          ],
        ),
      );
    }

    // Tablet
    return Padding(
      padding: EdgeInsets.only(
        top: GdsSpacing.spacing20,
        left: GdsSpacing.spacing20,
        right: GdsSpacing.spacing20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: GdsSpacing.spacing16,
        children: [
          _buildProfile(context, viewType),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: GdsSpacing.spacing8,
              children: [
                Text(user.name, style: GdsTypography.title1.copyWith(color: colors.text.grayBold)),
                GdsUserInfo.follow(
                  followerCount: user.followerCount ?? 0,
                  followingCount: user.followingCount ?? 0,
                  onFollowerTap: isMine ? () => FollowPage.push(context, 1) : null,
                  onFollowingTap: isMine ? () => FollowPage.push(context, 0) : null,
                ),
              ],
            ),
          ),
          _buildActions(context, ref, viewType),
        ],
      ),
    );
  }

  Widget _buildProfile(BuildContext context, ProfileViewType viewType) {
    if (viewType == ProfileViewType.mine) {
      onTap() => ProfileEditPage.push(context);

      return context.isMobile
          ? GdsProfileEditAvatar.ml(imageUrl: user.image, onTap: onTap)
          : GdsProfileEditAvatar.xl(imageUrl: user.image, onTap: onTap);
    }

    return GdsPersonAvatar(
      imageUrl: user.image,
      size: context.isMobile ? GdsAvatarSize.ml : GdsAvatarSize.xl,
    );
  }

  Widget _buildActions(
    BuildContext context,
    WidgetRef ref,
    ProfileViewType viewType,
  ) {
    final profileData = ref.read(profileDataProvider(user.url).notifier);
    final canFollow = user.isBlocked != true && user.isBlocking != true;
    final outlinedButtonSize = context.isMobile ? GdsOutlinedButtonSize.small : GdsOutlinedButtonSize.regular;
    final solidButtonSize = context.isMobile ? GdsSolidButtonSize.small : GdsSolidButtonSize.regular;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: GdsSpacing.spacing8,
      children: [
        if (viewType == ProfileViewType.mine) ...[
          GdsOutlinedButton(
            size: outlinedButtonSize,
            text: '프로필 편집',
            onPressed: () => ProfileEditPage.push(context),
          ),
        ] else if (canFollow) ...[
          if (user.isFollowing ?? false) ...[
            GdsOutlinedButton(
              size: outlinedButtonSize,
              text: '팔로잉 중',
              onPressed: () => profileData.toggleFollow(),
            ),
          ] else ...[
            GdsSolidButton(
              size: solidButtonSize,
              text: '팔로우',
              onPressed: () => profileData.toggleFollow(),
            ),
          ],
        ],
        GdsMenuAnchor(
          builder: (link) {
            return GdsOutlinedButton.icon(
              size: outlinedButtonSize,
              icon: GdsIcon.dotMenuHorizontal,
              onPressed: () => _showMoreMenuPopup(context, ref, link, viewType),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLinkWrap(BuildContext context) {
    assert(user.links?.isNotEmpty ?? false);
    final colors = context.gdsColors;
    final links = user.links!;
    final maxRenderingCount = 3;

    return Wrap(
      runSpacing: GdsSpacing.spacing4,
      spacing: GdsSpacing.spacing8,
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...links.take(maxRenderingCount).mapIndexed((index, link) {
          final linkType = LinkType.from(link);

          return GdsGesture(
            onTap: () => launchUrl(Uri.parse(link.link)),
            child: GdsUserItem.linkMain(icon: linkType.icon, siteText: link.linkName),
          );
        }),

        if (links.length > maxRenderingCount) ...[
          GdsGesture(
            onTap: () {
              assert(user.links?.isNotEmpty ?? false);
              showProfileLinkPopup(context, links);
            },
            child: Text(
              '외 링크 ${links.length - maxRenderingCount}개',
              style: GdsTypography.label5.copyWith(color: colors.text.primaryNormal),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _showMoreMenuPopup(
    BuildContext context,
    WidgetRef ref,
    LayerLink link,
    ProfileViewType viewType,
  ) {
    final isMine = viewType == ProfileViewType.mine;
    final items = [
      GdsMenuItem(
        label: '프로필 링크 공유',
        onTap: () {
          context.pop();

          final popup = GrimitySharePopup(
            url: AppConfig.buildUserUrl(user.url),
            shareContentType: ShareContentType.profile,
            nickname: user.name,
            description: user.name,
            imageUrl: user.image,
          );

          popup.show(context);
        },
      ),

      if (isMine) ...[
        GdsMenuItem(
          label: '회원 탈퇴',
          onTap: () {
            context.pop();
            _showDeleteAccountAlert(context, ref);
          },
        ),
        GdsMenuItem(
          label: '차단 목록',
          onTap: () {
            context.pop();
            context.isMobile ? BlockedUsersRoute().push(context) : showBlockedUsersModal(context);
          },
        ),
      ],

      if (!isMine) ...[
        GdsMenuItem(
          label: '메세지 보내기',
          onTap: () async {
            context.pop();

            final request = CreateChatRequest(targetUserId: user.id);
            final response = await getIt<RestClient>().chats.chatCreateChat(body: request);

            if (context.mounted) {
              ChatMessageRoute(response.id).push(context);
            }
          },
        ),
        GdsMenuItem(
          label: '신고하기',
          onTap: () {
            context.pop();
            ReportPage.push(context, refId: user.id, refType: ReportRefType.user);
          },
        ),

        if (user.isBlocking == true) ...[
          GdsMenuItem(
            label: '차단 해제',
            onTap: () async {
              context.pop();
              ref.read(profileDataProvider(user.url).notifier).unblockUser(user.id);
            },
          ),
        ] else ...[
          GdsMenuItem(
            label: '차단하기',
            onTap: () async {
              context.pop();
              ref.read(profileDataProvider(user.url).notifier).blockUser(user.id);
            },
          ),
        ],
      ],
    ];

    final popup = GrimityMenuPopup(layerLink: link, items: items);

    return popup.show(context, GdsMenuPosition.right);
  }

  Future<void> _showDeleteAccountAlert(BuildContext context, WidgetRef ref) {
    final alert = GdsAlert(
      size: context.isMobile ? GdsAlertSize.md : GdsAlertSize.xl,
      title: '정말 탈퇴하시겠어요?',
      description: '계정 복구는 어려워요.',
      primaryLabel: '탈퇴하기',
      onPrimaryTap: () async {
        final user = ref.read(userAuthProvider);
        if (user == null) {
          ToastService.showFailure('사용자 정보를 불러올 수 없어요');
          return;
        }

        context.pop();

        try {
          final provider = LoginProvider.fromString(user.provider ?? '');
          await completeDeleteUserProcessUseCase.execute(provider);
        } catch (_) {
          ToastService.showFailure('회원 탈퇴 실패했어요');
        }

        if (context.mounted) {
          SignInRoute().go(context);
        }
      },
      secondaryLabel: '취소',
      onSecondaryTap: context.pop,
    );

    return alert.open(context);
  }
}
