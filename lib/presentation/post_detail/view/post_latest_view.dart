import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/domain/entity/posts.dart';
import 'package:grimity/presentation/board/provider/board_post_data_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/common/widget/system/board/grimity_post_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PostLatestView extends ConsumerWidget {
  const PostLatestView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postProvider = boardPostDataProvider(PostType.all);
    final postNotifier = ref.watch(postProvider.notifier);
    final postAsync = ref.watch(postProvider);
    final colors = context.gdsColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
          ),
          child: Text(
            '최신 글',
            style: GdsTypography.title3.copyWith(color: colors.text.grayBold),
          ),
        ),
        postAsync.when(
          data: (posts) {
            return _PostListView(posts: posts, board: postNotifier);
          },
          loading: () {
            return Skeletonizer(
              child: _PostListView(posts: Posts.empty(), board: postNotifier),
            );
          },
          error: (_, _) {
            return GrimityStateView.error(onTap: () => ref.invalidate(postProvider));
          },
        ),
      ],
    );
  }
}

class _PostListView extends StatelessWidget {
  const _PostListView({
    required this.posts,
    required this.board,
  });

  final Posts posts;
  final BoardPostData board;

  @override
  Widget build(BuildContext context) {
    return GrimityPostView(
      posts: posts.posts,
      noticePosts: [],
      totalCount: posts.totalCount ?? 0,
      currentPage: board.currentPage,
      size: board.size,
      showPostType: true,
      isBookMark: true,
      shrinkWrap: true,
      onPageChanged: board.goToPage,
      cardHorizontalPadding: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
    );
  }
}
