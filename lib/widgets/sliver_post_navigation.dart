import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/util/post_service.dart';
import 'package:grimity/widgets/sliver_post_list.dart';

/// 게시글 목록의 페이지 이동 버튼을 표시하는 슬리버 위젯.
class SliverPostNavigation extends StatelessWidget {
  const new({
    super.key,
    required this.service,
    required this.onChanged,
  });

  final PostService service;

  /// 선택한 페이지 번호를 1부터 시작하는 값으로 전달하는 콜백.
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final data = service.maybeData ?? SliverPostList.placeholder;
    final totalCount = data.totalCount;
    final pageCount = (totalCount / 10).ceil();

    if (pageCount == 0) {
      return const SliverToBoxAdapter();
    }

    return SliverToBoxAdapter(
      child: Center(
        child: GdsNavigation(
          // API의 페이지 번호를 0부터 시작하는 인덱스로 변환.
          index: service.page - 1,
          pageCount: pageCount,
          maxCount: context.whenDevice(
            mobile: 5,
            tablet: 10,
          ),
          onChanged: (index) => onChanged(index + 1),
        ),
      ),
    );
  }
}
