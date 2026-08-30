import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_config.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_util_bar.dart';
import 'package:grimity/presentation/post_detail/provider/post_detail_data_provider.dart';
import 'package:grimity/presentation/post_detail/view/post_content_view.dart';

class PostUtilBar extends ConsumerWidget {
  const PostUtilBar({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isMine = ref.read(userAuthProvider)?.id == post.author?.id;

    final isLike = post.isLike ?? false;
    final isSave = post.isSave ?? false;

    return Row(
      children: [
        Expanded(
          child: GrimityUtilBar.post(
            isLike: isLike,
            isSave: isSave,
            likeCount: post.likeCount ?? 0,
            commentCount: post.commentCount ?? 0,
            shareUrl: AppConfig.buildPostUrl(post.id),
            onLikeTap: () =>
                ref.read(postDetailDataProvider(post.id).notifier).toggleLike(postId: post.id, like: !isLike),
            onSaveTap: () =>
                ref.read(postDetailDataProvider(post.id).notifier).toggleSave(postId: post.id, save: !isSave),
            title: post.title,
            thumbnail: post.thumbnail,
          ),
        ),
        GdsMenuAnchor(
          builder: (link) {
            return GdsIconButton(
              icon: GdsIcon.dotMenuHorizontal,
              onPressed: () {
                PostContentView.showMoreMenu(
                  context,
                  post: post,
                  isMine: isMine,
                  ref: ref,
                  layerLink: link,
                  showShare: true,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
