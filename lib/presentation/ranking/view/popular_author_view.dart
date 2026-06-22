import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/common/provider/author_with_feeds_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/common/widget/layout/anti_broken.dart';
import 'package:grimity/presentation/common/widget/user_card/grimity_author_with_feeds_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// 인기 작가
class PopularAuthorView extends ConsumerWidget {
  const PopularAuthorView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authorWithFeedsAsync = ref.watch(authorWithFeedsDataProvider);
    final colors = context.gdsColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing24,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
          ),
          child: Text(
            '인기 작가',
            style:
                context.isMobile
                    ? GdsTypography.title2.copyWith(color: colors.text.grayBold)
                    : GdsTypography.title1.copyWith(color: colors.text.grayBold),
          ),
        ),
        authorWithFeedsAsync.when(
          data: (authorWithFeeds) {
            return _PopularAuthorCarousel(authorWithFeedsList: authorWithFeeds);
          },
          loading: () {
            return Skeletonizer(
              child: _PopularAuthorCarousel(authorWithFeedsList: AuthorWithFeeds.createEmptyList(context)),
            );
          },
          error: (_, _) {
            return GrimityStateView.error(onTap: () => ref.invalidate(authorWithFeedsDataProvider));
          },
        ),
      ],
    );
  }
}

class _PopularAuthorCarousel extends HookConsumerWidget {
  const _PopularAuthorCarousel({required this.authorWithFeedsList});

  final List<AuthorWithFeeds> authorWithFeedsList;

  static final viewportFraction = 0.92;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController(viewportFraction: viewportFraction);
    final visibleUserCount = authorWithFeedsList.length > 5 ? 5 : authorWithFeedsList.length;

    return AntiSizedBroken(
      child: ExpandablePageView.builder(
        animationDuration: Duration.zero,
        animationCurve: Curves.linear,
        padEnds: false,
        itemCount: visibleUserCount,
        controller: pageController,
        itemBuilder: (context, index) {
          final authorWithFeeds = authorWithFeedsList[index];

          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 16 : 4, right: index == visibleUserCount - 1 ? 16 : 4),
            child: GrimityAuthorWithFeedsCard(
              authorWithFeeds: authorWithFeeds,
              onFollowTab:
                  () => ref
                      .read(authorWithFeedsDataProvider.notifier)
                      .toggleFollow(
                        id: authorWithFeeds.user.id,
                        follow: authorWithFeeds.user.isFollowing == false ? true : false,
                      ),
            ),
          );
        },
      ),
    );
  }
}
