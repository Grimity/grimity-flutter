// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/extensions/model/posts_response.dart';
import 'package:grimity/extensions/scroll_controller_extension.dart';
import 'package:grimity/presentation/search/widgets/search_empty_state.dart';
import 'package:grimity/util/post_service.dart';
import 'package:grimity/widgets/sliver_posts.dart';
import 'package:grimity/widgets/sliver_post_navigation.dart';
import 'package:grimity/widgets/sliver_scroll_view.dart';
import 'package:pervice/pervice.dart';

/// 검색어에 대응하는 게시글 목록을 표시하는 화면.
class SearchPosts extends StatelessWidget with GdsTabView {
  const new({super.key});

  @override
  String get label => '자유게시판';

  /// 검색 조건에 대응하는 게시글 목록을 조회하는 서비스를 생성합니다.
  static PostService createService(String keyword) {
    return .new(
      type: .all,
      keyword: keyword,
      searchBy: .combined,
      showNotices: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyword = context.sharedStateFor<String>(
      key: const ValueKey('search-keyword'),
    );

    final service = context.serviceOf(
      () => createService(keyword.value),
      key: ValueKey((keyword.value, SearchPosts)),
    );

    // 페이지 변경 시 게시글 목록을 맨 위로 이동하기 위한 컨트롤러.
    final controller = context.useNestedScrollController();

    // 보여줄 수 있는 게시글이 아예 없을 경우.
    if (service.maybeData?.posts.isEmpty == true) {
      return const SearchEmptyState();
    }

    return SliverScrollView(
      controller: controller,
      padding: context.whenDevice(
        mobile: .only(bottom: 40, left: 16, right: 16),
        tablet: .only(bottom: 40, left: 20, right: 20),
      ),
      spacing: context.whenDevice(
        mobile: 20,
        tablet: 24,
      ),
      slivers: [
        // 게시글 목록 표시
        service.sliver(
          placeholder: PostService.placeholder,
          builder: (data) {
            return SliverPosts(
              itemCount: data.itemCount,
              itemBuilder: data.itemBuilder,
            );
          },
        ),

        // 내비게이션 표시
        service.sliver(
          placeholder: PostService.placeholder,
          builder: (data) {
            return SliverPostNavigation(
              page: service.page,
              totalCount: data.totalCount.toInt(),
              onChanged: (index) {
                controller.animateToTop();
                service.nextPage(index);
              },
            );
          },
        ),
      ],
    );
  }
}
