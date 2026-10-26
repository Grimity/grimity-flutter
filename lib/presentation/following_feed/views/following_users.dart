import 'package:dynamic_height_list_view/dynamic_height_view.dart';
import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/following_feed/widgets/following_feed_section.dart';
import 'package:pervice/pervice.dart';

/// 팔로잉 피드 화면에서 인기 작가를 추천 카드 목록으로 표시하는 위젯.
class FollowingUsers extends StatelessWidget {
  const new({super.key});

  /// 인기 작가를 불러오는 동안 표시할 임시 데이터.
  static final placeholder = List.generate(20, (index) {
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

    return FollowingFeedSection(
      title: '인기 작가',
      child: service.sliver(
        placeholder: placeholder,
        builder: (data) {
          return SliverDynamicHeightGridView(
            crossAxisCount: context.whenDevice(mobile: 1, tablet: 2),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            itemCount: data.length,
            builder: (context, index) {
              final user = data[index];

              return GdsUser.normal(
                followerCount: user.followerCount.toInt(),
                followingCount: 0,
                nickname: user.name,
                profile: user.image?.toImage(),
                thumbnails: user.thumbnails.toImages(),
                following: user.isFollowing,
                onTap: () {}, // TODO
                onFollow: () {}, // TODO
                onUnFollow: () {}, // TODO
              );
            },
          );
        },
      ),
    );
  }
}
