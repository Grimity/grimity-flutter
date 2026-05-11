import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/app/util/sync_util.dart';
import 'package:grimity/domain/entity/post.dart';

/// 게시글 위젯
class GrimityPostCard extends StatefulWidget {
  GrimityPostCard({
    Key? key,
    required this.post,
    this.showPostType = false,
    this.keyword,
  }) : super(key: key ?? ValueKey(post.id));

  final Post post;
  final bool showPostType;
  final String? keyword;

  @override
  State<GrimityPostCard> createState() => _GrimityPostCardState();
}

class _GrimityPostCardState extends State<GrimityPostCard> {
  late Post post = widget.post;

  void onPostUpdate(Post newPost) {
    if (mounted) {
      setState(() => post = post.mergeWithoutContent(newPost));
    }
  }

  @override
  void initState() {
    super.initState();
    SyncUtil.post.listen(post, onPostUpdate);
  }

  @override
  void didUpdateWidget(covariant GrimityPostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.id != widget.post.id) {
      SyncUtil.post.cancel(oldWidget.post, onPostUpdate);
      SyncUtil.post.listen(widget.post, onPostUpdate);
      post = widget.post;
    } else if (oldWidget.post != widget.post) {
      post = post.mergeWithoutContent(widget.post);
    }
  }

  @override
  void dispose() {
    SyncUtil.post.cancel(post, onPostUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GdsGesture(
      onTap: () => PostDetailRoute(id: post.id).push(context),
      child: GdsUserItem.title(
        titleText: post.title,
        showTag: false,
        chip: widget.showPostType && post.type != null ? _buildPostTypeChip(post.type!) : null,
        userInfo: GdsUserInfo.community(
          viewCount: post.viewCount ?? 0,
          chatCount: post.commentCount ?? 0,
          showHeart: false,
          showTime: true,
          showChat: true,
          showView: widget.showPostType,
          timeText: post.createdAt.toRelativeTime(),
        ),
      ),
    );
  }

  GdsChip _buildPostTypeChip(String type) {
    final postType = PostType.fromString(type);
    return GdsChip(text: postType.typeName, size: GdsChipSize.medium);
  }
}
