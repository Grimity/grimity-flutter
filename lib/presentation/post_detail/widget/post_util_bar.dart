import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_config.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/common/widget/grimity_util_bar.dart';
import 'package:grimity/presentation/post_detail/provider/post_detail_data_provider.dart';

class PostUtilBar extends ConsumerWidget {
  final Post post;

  const PostUtilBar({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLike = post.isLike ?? false;
    final isSave = post.isSave ?? false;

    return GrimityUtilBar.post(
      isLike: isLike,
      isSave: isSave,
      likeCount: post.likeCount ?? 0,
      commentCount: post.commentCount ?? 0,
      shareUrl: AppConfig.buildPostUrl(post.id),
      onLikeTap: () => ref.read(postDetailDataProvider(post.id).notifier).toggleLike(postId: post.id, like: !isLike),
      onSaveTap: () => ref.read(postDetailDataProvider(post.id).notifier).toggleSave(postId: post.id, save: !isSave),
    );
  }
}
