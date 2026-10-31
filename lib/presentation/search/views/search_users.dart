// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:dynamic_height_list_view/dynamic_height_view.dart';
import 'package:flutter/material.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_use_case.dart';
import 'package:grimity/presentation/profile/pages/profile_page.dart';
import 'package:grimity/presentation/search/widgets/search_empty_state.dart';
import 'package:grimity/widgets/sliver_scroll_view.dart';
import 'package:pervice/pervice.dart';

/// 검색어에 대응하는 사용자 목록을 표시하는 화면.
class SearchUsers extends StatelessWidget with GdsTabView {
  const new({super.key});

  @override
  String get label => '작가';

  /// 검색 결과를 불러오는 동안 표시할 임시 사용자 데이터.
  static final placeholder = [
    SearchedUsersResponse(
      users: List.generate(10, (_) {
        return .new(
          id: '',
          name: 'Placeholder',
          url: '',
          description: 'Placeholder',
          isFollowing: true,
          followerCount: 0,
          isBlocking: false,
          isBlocked: false,
        );
      }),
    ),
  ];

  /// 검색 조건에 대응하는 사용자 목록을 조회하는 서비스를 생성합니다.
  static LoadMoreService<SearchedUsersResponse> createService(String keyword) {
    return .new(
      builder: (cursor) => GetUsersSearch(
        cursor: cursor,
        keyword: keyword,
      ),
      cursorOf: (data) => data.nextCursor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyword = context.sharedStateFor<String>(
      key: const ValueKey('search-keyword'),
    );

    final service = context.serviceOf(
      () => createService(keyword.value),
      key: ValueKey((keyword.value, SearchUsers)),
    );

    return service.builder(
      placeholder: placeholder,
      builder: (data) {
        final users = data.expand((e) => e.users).toList();

        // 보여줄 수 있는 작가가 아예 없을 경우.
        if (users.isEmpty) {
          return const SearchEmptyState();
        }

        return GdsInfiniteScroll(
          onLoadMore: service.loadMore,
          enabled: service.canLoreMore,
          child: SliverScrollView(
            padding: context.whenDevice(
              mobile: .all(16),
              tablet: .all(20),
            ),
            slivers: [
              SliverDynamicHeightGridView(
                crossAxisCount: context.whenDevice(
                  mobile: 1,
                  tablet: 2,
                ),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                itemCount: users.length,
                builder: (context, index) {
                  final user = users[index];

                  return buildItem(context, user);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// 검색된 사용자 정보에 대한 항목.
  Widget buildItem(BuildContext context, SearchedUserResponse user) {
    // SHARED STATE
    final followerCount = context.sharedStateOf(
      () => user.followerCount.toInt(),
      key: ValueKey('user-${user.id}:follower-count'),
    );

    final isFollowing = context.sharedStateOf(
      () => user.isFollowing,
      key: ValueKey('user-${user.id}:is-following'),
    );

    return GdsUser.search(
      nickname: user.name,
      introduction: user.description,
      profile: user.image?.toImage(),
      banner: user.backgroundImage?.toImage(),
      followerCount: followerCount.value,
      following: isFollowing.value,
      onTap: () {
        // 해당 사용자의 프로필 페이지로 이동.
        context.push(ProfilePage(url: user.url));
      },
      onFollow: () {
        AppUseCase.follow(
          context,
          id: user.id,
          isFollowing: isFollowing,
          followerCount: followerCount,
        );
      },
      onUnFollow: () {
        AppUseCase.unFollow(
          context,
          id: user.id,
          isFollowing: isFollowing,
          followerCount: followerCount,
        );
      },
    );
  }
}
