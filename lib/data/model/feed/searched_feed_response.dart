import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/feed/feed_base_response.dart';
import 'package:grimity/data/model/user/user_response.dart';
import 'package:grimity/domain/entity/feed.dart';

part 'searched_feed_response.freezed.dart';
part 'searched_feed_response.g.dart';

@Freezed(copyWith: false)
abstract class SearchedFeedResponse with _$SearchedFeedResponse implements FeedBaseResponse {
  const SearchedFeedResponse._();

  const factory SearchedFeedResponse({
    required String id,
    required String title,
    String? thumbnail,
    required int viewCount,
    required int likeCount,
    required UserResponse author,
    required int commentCount,
    required bool isLike,
    required List<String> tags,
  }) = _SearchedFeedResponse;

  factory SearchedFeedResponse.fromJson(Map<String, dynamic> json) => _$SearchedFeedResponseFromJson(json);
}

extension SearchedFeedResponseX on SearchedFeedResponse {
  Feed toEntity() {
    return Feed(
      id: id,
      title: title,
      thumbnail: thumbnail,
      viewCount: viewCount,
      likeCount: likeCount,
      author: author.toEntity(),
      commentCount: commentCount,
      isLike: isLike,
      tags: tags,
    );
  }
}

extension ListSearchedFeedResponseX on List<SearchedFeedResponse> {
  List<Feed> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
