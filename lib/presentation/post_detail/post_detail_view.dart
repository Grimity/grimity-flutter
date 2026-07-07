import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_drawer.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_title_top_navigation.dart';
import 'package:grimity/presentation/post_detail/view/post_latest_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostDetailView extends HookConsumerWidget {
  const PostDetailView({
    super.key,
    required this.post,
    required this.postContentView,
    required this.postCommentsView,
    required this.postCommentInputBar,
    required this.postUtilBar,
  });

  final Post post;
  final Widget postContentView;
  final Widget postCommentsView;
  final Widget postCommentInputBar;
  final Widget postUtilBar;

  Widget buildGap(BuildContext context) {
    return SliverToBoxAdapter(
      child: Gap(context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing24),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    return GdsScaffold(
      appBar: GrimityTitleTopNavigation(),
      drawer: const GrimityDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  buildGap(context),
                  SliverToBoxAdapter(child: postContentView),
                  SliverToBoxAdapter(child: Gap(GdsSpacing.spacing32)),
                  SliverToBoxAdapter(child: postCommentsView),
                  SliverToBoxAdapter(child: Gap(GdsSpacing.spacing56)),
                  SliverToBoxAdapter(child: PostLatestView()),
                  buildGap(context),
                ],
              ),
            ),
            postCommentInputBar,
          ],
        ),
      ),
    );
  }
}
