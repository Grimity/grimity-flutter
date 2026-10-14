import 'package:dio/dio.dart';
import 'package:dynamic_height_list_view/dynamic_height_view.dart';
import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/extensions/bool_extension.dart';
import 'package:grimity/presentation/feed_detail/pages/feed_detail_page.dart';
import 'package:pervice/pervice.dart';

/// 피드 카드에 표시할 이미지, 제목, 작성자와 좋아요 정보.
typedef SliverFeed = ({
  String id,
  String thumbnail,
  String title,
  String nickname,
  int likeCount,
  int viewCount,
  bool isLike,
});

/// 인덱스에 해당하는 피드 데이터를 반환하는 빌더.
typedef SliverFeedBuilder = SliverFeed Function(BuildContext context, int index);

/// 피드 카드를 동적 높이의 그리드로 표시하는 슬리버 위젯.
class SliverFeedGrid<T extends Service> extends StatelessWidget {
  const new({
    super.key,
    required this.service,
    required this.itemCount,
    required this.itemBuilder,
  });

  final T service;
  final int itemCount;
  final SliverFeedBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SliverDynamicHeightGridView(
      crossAxisCount: context.feedGridCrossAxisCount,
      crossAxisSpacing: 16,
      mainAxisSpacing: context.whenDevice(
        mobile: 24,
        tablet: 40,
      ),
      itemCount: itemCount,
      builder: (context, index) {
        final feed = itemBuilder(context, index);

        // SHARED STATE

        final isLike = context.sharedStateOf(
          () => feed.isLike,
          key: ValueKey('feed-${feed.id}:is-like'),
        );

        final likeCount = context.sharedStateOf(
          () => feed.likeCount,
          key: ValueKey('feed-${feed.id}:like-count'),
        );

        final viewCount = context.sharedStateOf(
          () => feed.viewCount,
          key: ValueKey('feed-${feed.id}:view-count'),
        );

        return service.build(
          child: GdsAlbum(
            image: feed.thumbnail.toImage(),
            title: feed.title,
            nickname: feed.nickname,
            likeCount: likeCount.value,
            viewCount: viewCount.value,
            like: isLike.value,
            onTap: () {
              // 피드 상세 페이지로 이동.
              context.push(FeedDetailPage(id: feed.id));
            },
            onLike: (value) async {
              try {
                // 요청 전에 좋아요 상태를 화면에 반영.
                isLike.value = value;
                likeCount.value += value ? 1 : -1;

                await value.feedLikeServiceOf(feed.id).request();
              } on DioException catch (_) {
                // 요청 실패 시 이전 상태로 복구.
                isLike.value = !value;
                likeCount.value += value ? -1 : 1;

                if (context.mounted) {
                  GdsToast.show(context, '좋아요 변경에 실패했어요.', status: .negative);
                }
              }
            },
          ),
        );
      },
    );
  }
}
