import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/util/post_service.dart';
import 'package:grimity/widgets/sliver_post_list.dart';
import 'package:grimity/widgets/sliver_post_navigation.dart';
import 'package:grimity/widgets/sliver_scroll_view.dart';
import 'package:pervice/pervice.dart';

/// 게시글 유형과 검색 조건에 맞는 목록과 페이지 이동 버튼을 표시하는 화면.
class BoardView extends StatelessWidget {
  const new({
    super.key,
    required this.postType,
    required this.searchBy,
    required this.keyword,
  });

  final PostTypeFilter postType;
  final PostSearchBy searchBy;
  final String keyword;

  @override
  Widget build(BuildContext context) {
    final key = ValueKey((postType, keyword, searchBy));

    final service = context.serviceOf(
      () => PostService(
        type: postType,
        keyword: keyword,
        searchBy: searchBy,
      ),
      key: key,
    );

    // 페이지 변경 시 게시글 목록을 맨 위로 이동하기 위한 컨트롤러.
    final controller = context.useNestedScrollController();

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
        SliverPostList(service: service),

        // 내비게이션 표시
        SliverPostNavigation(
          service: service,
          onChanged: (index) {
            controller.position.animateTo(
              0,
              duration: GdsAnimation.normal.duration,
              curve: GdsAnimation.normal.curve,
            );

            service.nextPage(index);
          },
        ),
      ],
    );
  }
}
