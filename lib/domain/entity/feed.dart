import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/extension/build_context_extension.dart';
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/domain/entity/comment.dart';
import 'package:grimity/domain/entity/user.dart';

part 'feed.freezed.dart';

part 'feed.g.dart';

@freezed
abstract class Feed with _$Feed {
  const factory Feed({
    required String id,
    required String title,
    String? thumbnail,
    List<String>? cards,
    DateTime? createdAt,
    int? viewCount,
    int? likeCount,
    String? content,
    List<String>? tags,
    User? author,
    bool? isLike,
    bool? isSave,
    int? commentCount,
    Album? album,
    Comment? comment,
  }) = _Feed;

  factory Feed.fromJson(Map<String, dynamic> json) => _$FeedFromJson(json);

  factory Feed.empty() =>
      Feed(id: '', title: 'Lorem ipsum dolor sit amet', thumbnail: '', viewCount: 0, likeCount: 0, commentCount: 0);

  static List<Feed> createEmptyList(BuildContext context) {
    return List.generate(context.feedRowCount + 1, (_) => Feed.empty());
  }
}
