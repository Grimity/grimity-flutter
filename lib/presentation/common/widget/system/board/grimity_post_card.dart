import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/app/util/sync_util.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/usecase/post_usecases.dart';

/// 게시글 위젯
class GrimityPostCard extends StatefulWidget {
  GrimityPostCard({
    Key? key,
    required this.post,
    this.showPostType = false,
    this.showBookMark = false,
    this.isBookMark = false,
    this.keyword,
  }) : super(key: key ?? ValueKey(post.id));

  final Post post;
  final bool showPostType;
  final bool showBookMark;
  final bool isBookMark;
  final String? keyword;

  @override
  State<GrimityPostCard> createState() => _GrimityPostCardState();
}

class _GrimityPostCardState extends State<GrimityPostCard> {
  late Post post = widget.post;
  bool _isBookmarkPending = false;

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

  Future<void> onBookmarkTap() async {
    if (_isBookmarkPending || post.id.isEmpty) return;

    final postId = post.id;
    final prevPost = post;
    final nextIsSave = !(post.isSave ?? false);
    final nextPost = post.copyWith(isSave: nextIsSave);

    setState(() {
      _isBookmarkPending = true;
      post = nextPost;
    });
    SyncUtil.post.notify(nextPost);

    final result = nextIsSave ? await savePostUseCase.execute(postId) : await removeSavedPostUseCase.execute(postId);

    result.fold(
      onSuccess: (_) {},
      onFailure: (_) {
        if (mounted) {
          setState(() => post = prevPost);
        }
        SyncUtil.post.notify(prevPost);
      },
    );

    if (mounted) {
      setState(() => _isBookmarkPending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = GdsUserInfo.community(
      viewCount: post.viewCount ?? 0,
      chatCount: post.commentCount ?? 0,
      showHeart: false,
      showTime: true,
      showChat: true,
      showView: widget.showPostType,
      timeText: post.createdAt.toRelativeTime(),
    );

    return GdsGesture(
      onTap: () => PostDetailRoute(id: post.id).push(context),
      child: Builder(
        builder: (context) {
          final chip = widget.showPostType ? _buildPostTypeChip(post.type ?? '') : null;

          if (widget.isBookMark) {
            return GdsUserItem.bookmark(
              titleText: post.title,
              showImageIcon: post.thumbnail != null,
              showTag: widget.showPostType,
              commentCount: post.commentCount ?? 0,
              contentText: post.content,
              userInfo: userInfo,
              chip: chip,
              showBookmark: widget.showBookMark,
              bookmark: GdsBookmark(
                isBookmarked: post.isSave ?? false,
                onTap: onBookmarkTap,
              ),
            );
          }

          return GdsUserItem.title(
            titleText: post.title,
            showTag: widget.showPostType,
            chip: chip,
            userInfo: userInfo,
          );
        },
      ),
    );
  }

  GdsChip _buildPostTypeChip(String type) {
    final postType = PostType.fromString(type);

    return GdsChip(
      text: postType.displayName,
      variant: postType.chipVariant,
      size: GdsChipSize.medium,
    );
  }
}
