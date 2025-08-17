import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/post_detail/post_detail_view.dart';
import 'package:grimity/presentation/post_detail/provider/post_detail_data_provider.dart';
import 'package:grimity/presentation/post_detail/view/post_content_view.dart';
import 'package:grimity/presentation/post_detail/widget/post_detail_app_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PostDetailPage extends ConsumerWidget {
  final String postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(postDetailDataProvider(postId));

    return postAsync.maybeWhen(
      data: (post) {
        post ??= Post.empty();

        return PostDetailView(
          post: post,
          postDetailAppBar: PostDetailAppBar(),
          postContentView: PostContentView(post: post),
        );
      },
      orElse: () {
        final post = Post.empty();

        return Skeletonizer(
          child: PostDetailView(
            post: post,
            postDetailAppBar: PostDetailAppBar(),
            postContentView: PostContentView(post: post),
          ),
        );
      },
    );
  }
}
