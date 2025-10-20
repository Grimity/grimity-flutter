import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/entity/users.dart';
import 'package:grimity/presentation/common/widget/grimity_circular_progress_indicator.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/common/widget/system/sort/grimity_search_sort_header.dart';
import 'package:grimity/presentation/common/widget/user_card/grimity_user_card.dart';
import 'package:grimity/presentation/home/hook/use_infinite_scroll_hook.dart';
import 'package:grimity/presentation/search/provider/search_user_data_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 검색 결과 피드 View
class SearchUserTabView extends HookConsumerWidget with SearchUserMixin {
  const SearchUserTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    return searchUserState(ref).maybeWhen(
      data:
          (users) =>
              users.users.isEmpty
                  ? GrimityStateView.resultNull(title: '검색 결과가 없어요', subTitle: '다른 검색어를 입력해보세요')
                  : _SearchResultUserView(users: users),
      orElse: () => GrimityCircularProgressIndicator(),
    );
  }
}

class _SearchResultUserView extends HookConsumerWidget with SearchUserMixin {
  const _SearchResultUserView({required this.users});

  final Users users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    useInfiniteScrollHook(
      ref: ref,
      scrollController: scrollController,
      loadFunction: () async => await searchUserNotifier(ref).loadMore(),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 8),
            sliver: SliverToBoxAdapter(child: _SearchUserSortHeader(resultCount: users.totalCount ?? 0)),
          ),
          _SearchUserSliverListView(users: users.users),
        ],
      ),
    );
  }
}

class _SearchUserSortHeader extends StatelessWidget {
  const _SearchUserSortHeader({required this.resultCount});

  final int resultCount;

  @override
  Widget build(BuildContext context) {
    return GrimitySearchSortHeader(resultCount: resultCount, padding: EdgeInsets.zero);
  }
}

class _SearchUserSliverListView extends ConsumerWidget with SearchUserMixin {
  const _SearchUserSliverListView({required this.users});

  final List<User> users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverList.separated(
      itemBuilder: (context, index) {
        final user = users[index];
        return GrimityUserCard(
          user: user,
          onFollowTap:
              () => searchUserNotifier(ref).toggleFollow(id: user.id, follow: user.isFollowing == false ? true : false),
        );
      },
      separatorBuilder: (context, index) => Gap(16),
      itemCount: users.length,
    );
  }
}
