import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/util/sync_util.dart';
import 'package:grimity/domain/entity/feed.dart';

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
      imageUrl: feed.thumbnail ?? '',
      type: (widget.index ?? 99) < 4 ? GdsAlbumCardType.rank : GdsAlbumCardType.mainTitle,
      rank: (widget.index ?? 99) < 4 ? (widget.index ?? 99) + 1 : 1,
      onTap: () => FeedDetailRoute(id: feed.id).push(context),
      onNicknameTap: () => feed.author != null ? ProfileRoute(url: feed.author!.url).push(context) : null,
    );
  }
}
