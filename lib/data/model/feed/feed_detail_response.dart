import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/album/album_base_response.dart';
import 'package:grimity/data/model/feed/feed_response.dart';
import 'package:grimity/data/model/user/user_base_response.dart';
import 'package:grimity/domain/entity/feed.dart';

part 'feed_detail_response.freezed.dart';
part 'feed_detail_response.g.dart';

@Freezed(copyWith: false)
abstract class FeedDetailResponse with _$FeedDetailResponse implements FeedResponse {
  const FeedDetailResponse._();

  const factory FeedDetailResponse({
    required String id,
    required String title,
    String? thumbnail,
    required List<String> cards,
    required DateTime createdAt,
    required int viewCount,
    required int likeCount,
    required String content,
    required List<String> tags,
    required UserBaseResponse author,
    required bool isLike,
    required bool isSave,
    required int commentCount,
    AlbumBaseResponse? album,
  }) = _FeedDetailResponse;

  factory FeedDetailResponse.fromJson(Map<String, dynamic> json) => _$FeedDetailResponseFromJson(json);
}

extension FeedDetailResponseX on FeedDetailResponse {
  Feed toEntity() {
    return Feed(
      id: id,
      title: title,
      thumbnail: thumbnail,
      cards: cards,
      createdAt: createdAt,
      viewCount: viewCount,
      likeCount: likeCount,
      content: content,
      tags: tags,
      author: author.toEntity(),
      isLike: isLike,
      isSave: isSave,
      commentCount: commentCount,
      album: album?.toEntity(),
    );
  }
}

extension ListFeedDetailResponseX on List<FeedDetailResponse> {
  List<Feed> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
