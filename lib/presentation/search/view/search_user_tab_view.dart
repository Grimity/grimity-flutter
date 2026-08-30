import 'package:dynamic_height_list_view/dynamic_height_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/extension/build_context_extension.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/entity/users.dart';
import 'package:grimity/presentation/common/widget/grimity_infinite_scroll_pagination.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/search/provider/search_user_data_provider.dart';
import 'package:grimity/presentation/search/view/search_empty_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// 검색 결과 피드 View
class SearchUserTabView extends HookConsumerWidget with SearchUserMixin {
  const SearchUserTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    return searchUserState(ref).when(
      data: (data) {
        final users = data.users;

        if (users.isEmpty) {
          return SearchEmptyState();
        }

        return GrimityInfiniteScrollPagination(
          isEnabled: data.nextCursor != null,
          onLoadMore: searchUserNotifier(ref).loadMore,
          child: _SearchResultUserView(users: data),
        );
      },
      loading: () => Skeletonizer(
        child: _SearchResultUserView(users: Users(users: User.emptyList)),
      ),
      error: (e, s) => GrimityStateView.error(onTap: () => invalidateSearchUser(ref)),
    );
  }
}

class _SearchResultUserView extends StatelessWidget {
  const _SearchResultUserView({required this.users});

  final Users users;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(
            context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
          ),
          sliver: _SearchUserSliverListView(users: users.users),
        ),
      ],
    );
  }
}

class _SearchUserSliverListView extends ConsumerWidget with SearchUserMixin {
  const _SearchUserSliverListView({required this.users});

  final List<User> users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverDynamicHeightGridView(
      crossAxisCount: context.userRowCount,
      mainAxisSpacing: GdsSpacing.spacing24,
      crossAxisSpacing: GdsSpacing.spacing16,
      itemCount: users.length,
      builder: (context, index) {
        final user = users[index];

        return GdsUserCard(
          type: GdsUserCardType.search,
          nickname: user.name,
          description: user.description ?? '',
          coverImageUrl: user.backgroundImage,
          profileImageUrl: user.image,
          followerCount: user.followerCount ?? 0,
          followingCount: user.followingCount ?? 0,
          actionLabel: (user.isFollowing ?? false) ? '팔로우 중' : '팔로잉',
          isActionSoild: !(user.isFollowing ?? false),
          onTap: () => ProfileRoute(url: user.url).push(context),
          onActionPressed: () {
            final newStatus = user.isFollowing == false ? true : false;
            searchUserNotifier(ref).toggleFollow(id: user.id, follow: newStatus);
          },
        );
      },
    );
  }
}
