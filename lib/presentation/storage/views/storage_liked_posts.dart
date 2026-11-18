// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/scroll_controller_extension.dart';
import 'package:grimity/presentation/navigation/navigation_page.dart';
import 'package:grimity/widgets/sliver_post_navigation.dart';
import 'package:grimity/widgets/sliver_posts.dart';
import 'package:grimity/widgets/sliver_scroll_view.dart';
import 'package:pervice/pervice.dart';

/// 좋아요한 글 목록을 표시하는 탭.
class StorageLikedPosts extends StatelessWidget with GdsTabView {
  const new({super.key});

  @override
  String get label => '좋아요한 글';

  /// 좋아요한 글을 불러오는 동안 표시할 임시 데이터.
  static final placeholder = MyLikePostsResponse(
    totalCount: 10,
    posts: List.generate(10, (_) {
      return .new(
        id: '',
        title: 'Placeholder',
        content: 'Placeholder',
        createdAt: .now(),
        type: .normal,
        viewCount: 0,
        commentCount: 0,
        author: const .new(
          id: '',
          name: 'Placeholder',
          url: '',
        ),
      );
    }),
  );

  @override
  Widget build(BuildContext context) {
    final page = context.stateOf(() => 1);

    // 페이지 인덱스를 기준으로 서비스 관리.
    final service = context.serviceOf(
      () => GetMeLikePosts(page: page.value),
      key: ValueKey((StorageLikedPosts, page.value)),
    );

    // 페이지 변경 시 게시글 목록을 맨 위로 이동하기 위한 컨트롤러.
    final controller = context.useNestedScrollController();

    return service.builder(
      placeholder: placeholder,
      builder: (data) {
        final posts = data.posts;

        // 좋아요한 글이 아예 없을 경우.
        if (posts.isEmpty == true) {
          return Align(
            alignment: .topCenter,
            child: GdsEmptyState(
              illust: .resultNull,
              title: '좋아요한 그림이 없어요',
              action: .new(
                type: .solid,
                label: '자유게시판 둘러보기',
                onTap: () {
                  // 초기 페이지로 이동.
                  context.popUntilFirst();

                  // 자유게시판 페이지로 이동.
                  NavigationPage.moveTo(context, 3);
                },
              ),
            ),
          );
        }

        return SliverScrollView(
          controller: controller,
          padding: context.whenDevice(
            mobile: 40.bottom + 16.horizontal,
            tablet: 40.bottom + 20.horizontal,
          ),
          spacing: context.whenDevice(
            mobile: 20,
            tablet: 24,
          ),
          slivers: [
            // 게시글 목록 표시
            SliverPosts(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return (
                  id: post.id,
                  nickname: post.author.name,
                  title: post.title,
                  content: post.content,
                  thumbnail: post.thumbnail,
                  type: post.type,
                  createdAt: post.createdAt,
                  viewCount: post.viewCount.toInt(),
                  commentCount: post.commentCount.toInt(),
                  isLike: true,
                );
              },
            ),

            // 내비게이션 표시
            SliverPostNavigation(
              page: page.value,
              totalCount: data.totalCount.toInt(),
              onChanged: (index) {
                controller.animateToTop();
                page.value = index;
              },
            ),
          ],
        );
      },
    );
  }
}
