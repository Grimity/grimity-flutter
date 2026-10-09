import 'package:dynamic_height_list_view/dynamic_height_view.dart';
import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/home/widgets/home_section.dart';

/// 홈 화면에서 최신 그림을 앨범 카드 그리드로 표시하는 위젯.
class HomeLatestFeeds extends StatelessWidget {
  const new({
    super.key,
    required this.service,
  });

  final LoadMoreService<LatestFeedsResponse> service;

  /// 최신 그림을 불러오는 동안 표시할 임시 피드 데이터.
  static final placeholder = [
    LatestFeedsResponse(
      feeds: List.generate(10, (_) {
        return .new(
          id: '',
          title: 'Placeholder',
          thumbnail: '',
          likeCount: 0,
          viewCount: 0,
          author: .new(id: '', name: 'Placeholder', url: ''),
          createdAt: .now(),
          isLike: false,
        );
      }),
    ),
  ];

  /// 최신 그림 목록을 조회하는 서비스를 생성합니다.
  static LoadMoreService<LatestFeedsResponse> createService() {
    return .new(
      builder: (cursor) => GetFeedsLatest(cursor: cursor),
      cursorOf: (data) => data.nextCursor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = service.maybeData ?? placeholder;
    final feeds = data.expand((e) => e.feeds).toList();

    return HomeSection.sliver(
      header: .new(
        title: '최신 그림',
        onMore: () {}, // TODO
      ),
      child: SliverDynamicHeightGridView(
        crossAxisCount: context.feedGridCrossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: context.whenDevice(
          mobile: 24,
          tablet: 40,
        ),
        itemCount: feeds.length,
        builder: (context, index) {
          return service.build(child: buildFeed(feeds[index]));
        },
      ),
    );
  }

  /// 각 피드를 앨범 카드로 표시하는 빌더.
  Widget buildFeed(LatestFeedResponse feed) {
    return GdsAlbum(
      image: feed.thumbnail.responsiveImage,
      title: feed.title,
      nickname: feed.author.name,
      likeCount: feed.likeCount.toInt(),
      viewCount: feed.viewCount.toInt(),
      like: feed.isLike,
      onTap: () {}, // TODO
      onLike: (_) {}, // TODO
    );
  }
}
