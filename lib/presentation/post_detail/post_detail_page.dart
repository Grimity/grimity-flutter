import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/comment/enum/comment_type.dart';
import 'package:grimity/presentation/comment/view/comments_view.dart';
import 'package:grimity/presentation/comment/widget/comment_input_bar.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/post_detail/post_detail_view.dart';
import 'package:grimity/presentation/post_detail/provider/post_detail_data_provider.dart';
import 'package:grimity/presentation/post_detail/view/post_content_view.dart';
import 'package:grimity/presentation/post_detail/widget/post_detail_app_bar.dart';
import 'package:grimity/presentation/post_detail/widget/post_util_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PostDetailPage extends ConsumerWidget {
  final String postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(postDetailDataProvider(postId));

    return postAsync.when(
      data: (post) {
        post ??= Post.empty();

        return PostDetailView(
          post: post,
          postDetailAppBar: PostDetailAppBar(),
          postContentView: PostContentView(post: post),
          postCommentsView: CommentsView(
            id: post.id,
            authorId: post.author?.id ?? '',
            commentCount: post.commentCount ?? 0,
            commentType: CommentType.post,
          ),
          postCommentInputBar: CommentInputBar(id: post.id, commentType: CommentType.post),
          postUtilBar: PostUtilBar(post: post),
        );
      },
      loading: () {
        final post = Post.empty();

        return Skeletonizer(
          child: PostDetailView(
            post: post,
            postDetailAppBar: PostDetailAppBar(),
            postContentView: PostContentView(post: post),
            postCommentsView: CommentsView(
              id: post.id,
              authorId: post.author?.id ?? '',
              commentCount: post.commentCount ?? 0,
              commentType: CommentType.post,
            ),
            postCommentInputBar: CommentInputBar(id: post.id, commentType: CommentType.post),
            postUtilBar: PostUtilBar(post: post),
          ),
        );
      },
      error:
          (e, s) => Scaffold(
            appBar: AppBar(),
            body: GrimityStateView.error(onTap: () => ref.invalidate(postDetailDataProvider(postId))),
          ),
    );
  }
}
