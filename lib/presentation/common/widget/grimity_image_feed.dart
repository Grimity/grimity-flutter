import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/util/sync_util.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/common/widget/grimity_highlight_text_span.dart';
import 'package:grimity/presentation/common/widget/grimity_image.dart';
import 'package:grimity/presentation/common/widget/grimity_reaction.dart';

class GrimityImageFeed extends StatefulWidget {
  GrimityImageFeed({
    Key? key,
    required this.feed,
    this.authorName,
    this.index,
    this.keyword,
  }) : super(key: key ?? ValueKey(feed.id));

  final Feed feed;
  final String? authorName;
  final int? index;
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
    return GrimityGesture(
      onTap: () => FeedDetailRoute(id: feed.id).push(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: GrimityImage.infinity(
              imageUrl: feed.thumbnail ?? '',
              index: widget.index,
            ),
          ),
          const Gap(8),
          Flexible(
            child: GrimityHighlightTextSpan(text: feed.title, keyword: widget.keyword, normal: AppTypeface.label2),
          ),
          const Gap(2),
          GrimityReaction.nameLikeView(
            name: feed.author?.name ?? widget.authorName,
            likeCount: feed.likeCount,
            viewCount: feed.viewCount,
            onNameTap: () {
              if (feed.author != null) {
                ProfileRoute(url: feed.author!.url).push(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
