import 'package:flexible_horizontal_list_view/flexible_horizontal_list_view.dart';
import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/ranking_feed/widgets/feed_rankings_section.dart';
import 'package:pervice/pervice.dart';

/// 인기 작가 정보를 가로 카드 목록으로 표시하는 위젯.
class RankingFeedUsers extends StatelessWidget {
  const new({super.key});

  /// 인기 작가를 불러오는 동안 표시할 임시 데이터.
  static final placeholder = List.generate(5, (index) {
    return PopularUserResponse(
      id: '',
      name: 'Placeholder',
      url: '',
      description: 'Placeholder',
      followerCount: 0,
      isFollowing: false,
      thumbnails: [],
      isBlocking: false,
      isBlocked: false,
    );
  });

  @override
  Widget build(BuildContext context) {
    final service = context.serviceOf(GetUsersPopular.new);

    return FeedRankingsSection(
      title: '인기 작가',
      child: service.builder(
        placeholder: placeholder,
        builder: (data) {
          return HorizontalListView.separated(
            clipBehavior: .none,
            itemCount: data.length,
            separatorBuilder: (_, _) => 16.horizontalGap,

            // 대용량 이미지로 인한 성능 이슈로 0 픽셀로 조정.
            cacheExtent: 0,
            itemBuilder: (context, index) {
              final user = data[index];

              return service.build(
                child: GdsUser.normal(
                  followerCount: user.followerCount.toInt(),
                  followingCount: 0,
                  nickname: user.name,
                  profile: user.image?.responsiveImage,
                  thumbnails: user.thumbnails.builder((e) => e.responsiveImage),
                  following: user.isFollowing,
                  onTap: () {}, // TODO
                  onFollow: () {}, // TODO
                  onUnFollow: () {}, // TODO
                ),
              );
            },
          );
        },
      ),
    );
  }
}
