// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_use_case.dart';
import 'package:grimity/extensions/model/link_response.dart';
import 'package:grimity/extensions/model/user_profile_response.dart';
import 'package:pervice/pervice.dart';
import 'package:url_launcher/url_launcher.dart';

/// 사용자 정보와 프로필 관련 버튼을 표시하는 헤더 위젯.
class ProfileHeader extends GdsAdaptiveWidget {
  const new({
    super.key,
    required this.data,
  });

  final UserProfileResponse data;

  @override
  Widget buildMobile(BuildContext context) {
    return Padding(
      padding: .only(top: 16, bottom: 12, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        spacing: 12,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              // 프로필 이미지 표시
              if (data.isMe) ...[
                GdsProfileEdit(
                  size: .ml,
                  image: data.image?.toImage(),
                  onTap: onProfileEdit,
                ),
              ] else ...[
                GdsProfile(
                  size: .ml,
                  image: data.image?.toImage(),
                ),
              ],

              // 액션 버튼 표시
              Row(
                mainAxisSize: .min,
                spacing: 8,
                children: [
                  if (data.isMe) ...[
                    GdsButton.text(
                      type: .outlined,
                      size: .sm,
                      label: '프로필 편집',
                      onTap: onProfileEdit,
                    ),
                  ] else ...[
                    _FollowButton(data: data),
                  ],

                  GdsButton.text(
                    type: .outlined,
                    size: .sm,
                    leadingIcon: .dotmenuHorizontal,
                    onTap: onMenu,
                  ),
                ],
              ),
            ],
          ),

          Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            spacing: 8,
            children: [
              // 닉네임 표시
              GdsText(
                data.name,
                color: .textGrayBold,
                style: .title2,
              ),

              // 팔로우, 팔로잉 개수 표시
              GdsUserInfo.follow(
                followerCount: data.followerCount.toInt(),
                followingCount: data.followingCount.toInt(),
              ),
            ],
          ),

          // 소개글 표시
          if (data.description.isNotEmpty) ...[
            GdsText(
              data.description,
              color: .textGrayBold,
              style: .label6,
            ),
          ],

          // 링크 목록 표시
          if (data.links.isNotEmpty) ...[
            _Links(links: data.links),
          ],
        ],
      ),
    );
  }

  @override
  Widget buildTablet(BuildContext context) {
    return Padding(
      padding: .only(top: 20, bottom: 24, left: 20, right: 20),
      child: Row(
        spacing: 16,
        children: [
          // 프로필 이미지 표시
          if (data.isMe) ...[
            GdsProfileEdit(
              size: .xl,
              image: data.image?.toImage(),
              onTap: onProfileEdit,
            ),
          ] else ...[
            GdsProfile(
              size: .xl,
              image: data.image?.toImage(),
            ),
          ],

          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              spacing: 12,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        mainAxisSize: .min,
                        spacing: 8,
                        children: [
                          // 닉네임 표시
                          GdsText(
                            data.name,
                            color: .textGrayBold,
                            style: .title1,
                          ),

                          // 팔로우, 팔로잉 개수 표시
                          GdsUserInfo.follow(
                            followerCount: data.followerCount.toInt(),
                            followingCount: data.followingCount.toInt(),
                          ),
                        ],
                      ),
                    ),

                    // 액션 버튼 표시
                    Row(
                      mainAxisSize: .min,
                      spacing: 8,
                      children: [
                        if (data.isMe) ...[
                          GdsButton.text(
                            type: .outlined,
                            size: .md,
                            label: '프로필 편집',
                            onTap: onProfileEdit,
                          ),
                        ] else ...[
                          _FollowButton(data: data),
                        ],

                        GdsButton.text(
                          type: .outlined,
                          size: .md,
                          leadingIcon: .dotmenuHorizontal,
                          onTap: onMenu,
                        ),
                      ],
                    ),
                  ],
                ),

                // 소개글 표시
                if (data.description.isNotEmpty) ...[
                  GdsText(
                    data.description,
                    color: .textGrayBold,
                    style: .label6,
                  ),
                ],

                // 링크 목록 표시
                if (data.links.isNotEmpty) ...[
                  _Links(links: data.links),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///
  void onProfileEdit() {}

  ///
  void onMenu() {}
}

/// 사용자 프로필의 링크 목록과 더보기를 표시하는 위젯.
class _Links extends StatelessWidget {
  const new({required this.links});

  final List<LinkResponse> links;

  /// 프로필에 표시할 링크의 최대 개수.
  static const maxCount = 3;

  @override
  Widget build(BuildContext context) {
    final visibleLinks = links.take(maxCount).toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: .center,
      children: [
        // 링크 목록 표시
        ...visibleLinks.builder((link) {
          return GdsUserItem.link(
            name: link.linkName,
            icon: link.icon,
            onTap: () => launchUrl(link.uri),
          );
        }),

        // 표시 개수를 초과한 링크가 있으면 더보기 표시
        if (links.length > maxCount) ...[
          GdsGesture(
            onTap: () {}, // TODO
            child: GdsText(
              '외 링크 ${links.length - maxCount}개',
              color: .textPrimaryNormal,
              style: .label5,
            ),
          ),
        ],
      ],
    );
  }
}

/// 사용자의 팔로우 상태에 따라 팔로우 및 언팔로우 버튼을 표시하는 위젯.
class _FollowButton extends StatelessWidget {
  const new({required this.data});

  final UserProfileResponse data;

  @override
  Widget build(BuildContext context) {
    // SHARED STATE
    final followerCount = context.sharedStateOf(
      () => data.followerCount.toInt(),
      key: ValueKey('user-${data.id}:follower-count'),
    );

    final isFollowing = context.sharedStateOf(
      () => data.isFollowing,
      key: ValueKey('user-${data.id}:is-following'),
    );

    // 팔로우 상태에 따른 버튼 액션 생성.
    final action = GdsTextButtonAction.follow(
      following: isFollowing.value,
      onFollow: () {
        AppUseCase.follow(
          context,
          id: data.id,
          isFollowing: isFollowing,
          followerCount: followerCount,
        );
      },
      onUnFollow: () {
        AppUseCase.unFollow(
          context,
          id: data.id,
          isFollowing: isFollowing,
          followerCount: followerCount,
        );
      },
    );

    return GdsButton.text(
      type: action.type,
      size: context.whenDevice(
        mobile: .sm,
        tablet: .md,
      ),
      label: action.label,
      onTap: action.onTap,
    );
  }
}
