import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/util/post_service.dart';
import 'package:grimity/widgets/sliver_column.dart';
import 'package:grimity/widgets/sliver_post_list.dart';
import 'package:grimity/widgets/sliver_post_navigation.dart';
import 'package:pervice/pervice.dart';

/// 글 상세에서 공지를 제외한 최신 게시글 목록을 표시하는 위젯.
class PostDetailLatestPosts extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final service = context.serviceOf(
      () => PostService(
        type: .all,
        keyword: '',
        searchBy: .combined,
        showNotices: false,
      ),
      key: key,
    );

    return SliverColumn(
      children: [
        // 섹션 제목 표시
        SliverToBoxAdapter(
          child: GdsText(
            '최신 글',
            color: .textGrayBold,
            style: .title3,
          ),
        ),

        // 게시글 목록 표시
        SliverPostList(service: service),
        SliverGap(
          context.whenDevice(
            mobile: 20,
            tablet: 24,
          ),
        ),

        // 내비게이션 표시
        SliverPostNavigation(
          service: service,
          onChanged: service.nextPage,
        ),
      ],
    );
  }
}
