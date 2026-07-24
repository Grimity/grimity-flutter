import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/extension/string_extension.dart';
import 'package:grimity/app/util/sync_util.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/usecase/feed_usecases.dart';

class GrimityImageFeed extends StatefulWidget {
  GrimityImageFeed({
    Key? key,
    required this.feed,
    this.index,
    this.authorName,
    this.keyword,
  }) : super(key: key ?? ValueKey(feed.id));

  final Feed feed;
  final int? index;
  final String? authorName;
  final String? keyword;

  @override
  State<GrimityImageFeed> createState() => _GrimityImageFeedState();
}

class _GrimityImageFeedState extends State<GrimityImageFeed> {
  late Feed feed = widget.feed;
  bool isHeartLoading = false;

  void onFeedUpdate(Feed newFeed) {
    if (mounted) {
      setState(() => feed = newFeed);
    }
  }

  @override
  void initState() {
    super.initState();
    SyncUtil.feed.listen(feed, onFeedUpdate);
  }

  @override
  void didUpdateWidget(covariant GrimityImageFeed oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.feed.id != widget.feed.id) {
      SyncUtil.feed.cancel(oldWidget.feed, onFeedUpdate);
      SyncUtil.feed.listen(widget.feed, onFeedUpdate);
      feed = widget.feed;
    }
  }

  @override
  void dispose() {
    SyncUtil.feed.cancel(feed, onFeedUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GdsAlbumCard(
      width: double.infinity,
      title: feed.title,
      nickname: widget.authorName ?? feed.author?.name,
      heartCount: feed.likeCount,
      viewCount: feed.viewCount,
      imageUrlBuilder: (width, height) {
        return feed.thumbnail?.imageUrlBuilder(context, width, height) ?? '';
      },
      isLiked: feed.isLike ?? false,
      type: (widget.index ?? 99) < 4 ? GdsAlbumCardType.rank : GdsAlbumCardType.mainTitle,
      rank: (widget.index ?? 99) < 4 ? (widget.index ?? 99) + 1 : 1,
      onTap: () => FeedDetailRoute(id: feed.id).push(context),
      onNicknameTap: () => feed.author != null ? ProfileRoute(url: feed.author!.url).push(context) : null,
      onHeartTap: onHeartTap,
    );
  }

  Future<void> onHeartTap() async {
    if (isHeartLoading || feed.id.isEmpty) return;
    isHeartLoading = true;

    final prev = feed;
    final like = !(prev.isLike ?? false);
    final optimistic = prev.copyWith(
      isLike: like,
      likeCount: like ? (prev.likeCount ?? 0) + 1 : ((prev.likeCount ?? 0) - 1).clamp(0, double.infinity).toInt(),
    );

    SyncUtil.feed.notify(optimistic);

    try {
      final result = like ? await likeFeedUseCase.execute(prev.id) : await unlikeFeedUseCase.execute(prev.id);

      result.fold(
        onSuccess: (_) {},
        onFailure: (_) => SyncUtil.feed.notify(prev),
      );
    } finally {
      isHeartLoading = false;
    }
  }
}
