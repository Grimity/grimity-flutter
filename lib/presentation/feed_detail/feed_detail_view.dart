import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_drawer.dart';

class FeedDetailView extends StatelessWidget {
  final Feed feed;
  final Widget feedDetailAppBar;
  final Widget feedContentView;
  final Widget? feedCommentsView;
  final Widget feedAuthorProfileView;
  final Widget feedRecommendFeedView;
  final Widget? feedCommentInputBar;

  const FeedDetailView({
    super.key,
    required this.feed,
    required this.feedDetailAppBar,
    required this.feedContentView,
    required this.feedCommentsView,
    required this.feedAuthorProfileView,
    required this.feedRecommendFeedView,
    required this.feedCommentInputBar,
  });

  static Widget buildGap(double spacing) {
    return SliverToBoxAdapter(child: Gap(spacing));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;

    return GdsScaffold(
      appBar: feedDetailAppBar,
      drawer: const GrimityDrawer(),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: feedContentView),
                buildGap(GdsSpacing.spacing32),
                SliverToBoxAdapter(child: feedCommentsView),
                buildGap(GdsSpacing.spacing56),
                SliverToBoxAdapter(child: feedAuthorProfileView),
                buildGap(GdsSpacing.spacing56),
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
                    right: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
                    bottom: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing24,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      '추천 그림',
                      style: GdsTypography.title3.copyWith(color: colors.text.grayBold),
                    ),
                  ),
                ),
                feedRecommendFeedView,
              ],
            ),
          ),

          if (feedCommentInputBar != null) feedCommentInputBar!,
        ],
      ),
    );
  }
}
