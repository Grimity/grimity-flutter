import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/feed/feed_base_response.dart';
import 'package:grimity/data/model/user/user_response.dart';
import 'package:grimity/domain/entity/feed.dart';

part 'searched_feed_by_tags_response.freezed.dart';
part 'searched_feed_by_tags_response.g.dart';

@Freezed(copyWith: false)
abstract class SearchedFeedByTagsResponse with _$SearchedFeedByTagsResponse implements FeedBaseResponse {
  const SearchedFeedByTagsResponse._();

  const factory SearchedFeedByTagsResponse({
    required String id,
    required String title,
    String? thumbnail,
    required int likeCount,
    required int viewCount,
    required bool isLike,
    required UserResponse author,
  }) = _SearchedFeedByTagsResponse;

  factory SearchedFeedByTagsResponse.fromJson(Map<String, dynamic> json) => _$SearchedFeedByTagsResponseFromJson(json);
}

extension SearchedFeedByTagsResponseX on SearchedFeedByTagsResponse {
  Feed toEntity() {
    return Feed(
      id: id,
      title: title,
      thumbnail: thumbnail,
      likeCount: likeCount,
      viewCount: viewCount,
      isLike: isLike,
      author: author.toEntity(),
    );
  }
}

extension ListSearchedFeedByTagsResponseX on List<SearchedFeedByTagsResponse> {
  List<Feed> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
