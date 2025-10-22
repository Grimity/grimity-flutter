import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/common/provider/author_with_feeds_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/common/widget/user_card/grimity_author_with_feeds_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FollowingFeedRecommendAuthorListView extends ConsumerWidget {
  const FollowingFeedRecommendAuthorListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authorWithFeedsAsync = ref.watch(authorWithFeedsDataProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Text('추천 작가', style: AppTypeface.subTitle1.copyWith(color: AppColor.gray800)),
          authorWithFeedsAsync.when(
            data: (authorWithFeedsList) => _AuthorWithFeedsListView(authorWithFeedsList: authorWithFeedsList),
            loading:
                () => Skeletonizer(child: _AuthorWithFeedsListView(authorWithFeedsList: AuthorWithFeeds.emptyList)),
            error: (e, s) => GrimityStateView.error(onTap: () => ref.invalidate(authorWithFeedsDataProvider)),
          ),
        ],
      ),
    );
  }
}

class _AuthorWithFeedsListView extends ConsumerWidget {
  const _AuthorWithFeedsListView({required this.authorWithFeedsList});

  final List<AuthorWithFeeds> authorWithFeedsList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: authorWithFeedsList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final authorWithFeeds = authorWithFeedsList[index];

        return GrimityAuthorWithFeedsCard(
          authorWithFeeds: authorWithFeeds,
          onFollowTab:
              () => ref
                  .read(authorWithFeedsDataProvider.notifier)
                  .toggleFollow(
                    id: authorWithFeeds.user.id,
                    follow: authorWithFeeds.user.isFollowing == false ? true : false,
                  ),
        );
      },
      separatorBuilder: (context, index) => Gap(24),
    );
  }
}
