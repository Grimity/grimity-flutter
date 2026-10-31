// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/model/user_profile_response.dart';
import 'package:grimity/extensions/scroll_controller_extension.dart';
import 'package:grimity/presentation/post_upload/pages/post_upload_page.dart';
import 'package:grimity/presentation/profile/widgets/profile_content_toolbar.dart';
import 'package:grimity/widgets/sliver_column.dart';
import 'package:grimity/widgets/sliver_post_navigation.dart';
import 'package:grimity/widgets/sliver_posts.dart';
import 'package:grimity/widgets/sliver_scroll_view.dart';
import 'package:pervice/pervice.dart';

/// 프로필 화면에서 사용자의 글을 조회하고 이를 표시하는 위젯.
class ProfilePosts extends StatelessWidget with GdsTabView {
  const new({
    super.key,
    required this.data,
  });

  final UserProfileResponse data;

  @override
  String get label => '글';

  @override
  int get count => data.postCount.toInt();

  /// 게시글을 불러오는 동안 표시할 임시 게시글 데이터.
  static final placeholder = List.generate(10, (_) {
    return MyPostResponse(
      id: '',
      type: .normal,
      title: 'Placeholder',
      content: 'Placeholder',
      viewCount: 0,
      commentCount: 0,
      createdAt: .now(),
    );
  });

  /// 사용자의 글 목록을 불러오는 서비스를 생성합니다.
  GetUsersByIdPosts createService(int? page) {
    return .new(id: data.id, page: page);
  }

  @override
  Widget build(BuildContext context) {
    final page = context.stateOf(() => 1);

    // 페이지 인덱스를 기준으로 서비스 관리.
    final service = context.serviceOf(
      () => createService(page.value),
      key: ValueKey(page.value),
    );

    // 페이지 변경 시 게시글 목록을 맨 위로 이동하기 위한 컨트롤러.
    final controller = context.useNestedScrollController();

    return SliverScrollView(
      padding: context.whenDevice(
        mobile: .only(top: 16, bottom: 40, left: 16, right: 16),
        tablet: .only(top: 20, bottom: 72, left: 20, right: 20),
      ),
      slivers: [
        // 글 개수와 정렬 버튼 표시
        SliverToBoxAdapter(
          child: ProfileContentToolbar(
            count: count,
            filterBuilder: (context, layerLink) {
              return GdsFilter(
                variant: .text,
                enabled: false,
                label: '최신순',
              );
            },
          ),
        ),

        service.sliver(
          placeholder: placeholder,
          builder: (posts) {
            // 보여줄 수 있는 게시글이 아예 없을 경우.
            if (posts.isEmpty) {
              return SliverToBoxAdapter(
                child: _EmptyState(isMe: data.isMe),
              );
            }

            return SliverColumn(
              spacing: context.whenDevice(
                mobile: 20,
                tablet: 24,
              ),
              children: [
                // 게시글 목록 표시
                SliverPosts(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];

                    return (
                      id: post.id,
                      nickname: data.name,
                      title: post.title,
                      content: post.content,
                      thumbnail: post.thumbnail,
                      type: post.type,
                      createdAt: post.createdAt,
                      viewCount: post.viewCount.toInt(),
                      commentCount: post.commentCount.toInt(),
                    );
                  },
                ),

                // 내비게이션 표시
                service.sliver(
                  placeholder: placeholder,
                  builder: (posts) {
                    return SliverPostNavigation(
                      page: page.value,
                      totalCount: data.postCount.toInt(),
                      onChanged: (index) {
                        controller.animateToTop();
                        page.value = index;
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// 프로필에 표시할 게시글이 없을 때 표시하는 위젯.
class _EmptyState extends StatelessWidget {
  const new({required this.isMe});

  final bool isMe;

  @override
  Widget build(BuildContext context) {
    if (isMe) {
      return GdsEmptyState(
        illust: .illustReply,
        title: '첫 글을 업로드해보세요',
        action: .new(
          type: .solid,
          label: '글 업로드',
          onTap: () {
            // 게시글 업로드 페이지로 이동.
            context.push(const PostUploadPage());
          },
        ),
      );
    }

    return GdsEmptyState(
      illust: .resultNull,
      title: '업로드한 글이 없어요',
    );
  }
}
