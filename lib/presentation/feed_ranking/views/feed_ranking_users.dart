import 'package:flexible_horizontal_list_view/flexible_horizontal_list_view.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_use_case.dart';
import 'package:grimity/presentation/feed_ranking/widgets/feed_ranking_section.dart';
import 'package:pervice/pervice.dart';

/// 인기 작가 정보를 가로 카드 목록으로 표시하는 위젯.
class FeedRankingUsers extends StatelessWidget {
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

    return FeedRankingSection(
      title: '인기 작가',
      child: service.builder(
        placeholder: placeholder,
        builder: (users) {
          return HorizontalListView.separated(
            clipBehavior: .none,
            itemCount: users.length,
            separatorBuilder: (_, _) => const Gap(16),

            // 대용량 이미지로 인한 성능 이슈로 0 픽셀로 조정.
            cacheExtent: 0,
            itemBuilder: (context, index) {
              final user = users[index];

              return service.build(
                child: buildItem(context, user),
              );
            },
          );
        },
      ),
    );
  }

  /// 인기 사용자 정보를 팔로우 상태와 함께 표시합니다.
  Widget buildItem(BuildContext context, PopularUserResponse user) {
    // SHARED STATE
    final followerCount = context.sharedStateOf(
      () => user.followerCount.toInt(),
      key: ValueKey('feed-${user.id}:follower-count'),
    );

    final isFollowing = context.sharedStateOf(
      () => user.isFollowing,
      key: ValueKey('feed-${user.id}:is-following'),
    );

    return GdsUser.normal(
      followerCount: followerCount.value,
      followingCount: 0,
      nickname: user.name,
      profile: user.image?.toImage(),
      thumbnails: user.thumbnails.toImages(),
      following: isFollowing.value,
      onTap: () {}, // TODO
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
