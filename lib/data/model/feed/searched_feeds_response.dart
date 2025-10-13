import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/feed/searched_feed_response.dart';
import 'package:grimity/data/model/shared/cursor_and_count_response.dart';
import 'package:grimity/domain/entity/feeds.dart';

part 'searched_feeds_response.freezed.dart';

part 'searched_feeds_response.g.dart';

@Freezed(copyWith: false)
abstract class SearchedFeedsResponse with _$SearchedFeedsResponse implements CursorAndCountResponse {
  const SearchedFeedsResponse._();

  const factory SearchedFeedsResponse({
    String? nextCursor,
    required int totalCount,
    required List<SearchedFeedResponse> feeds,
  }) = _SearchedFeedsResponse;

  factory SearchedFeedsResponse.fromJson(Map<String, dynamic> json) => _$SearchedFeedsResponseFromJson(json);
}

extension SearchedFeedsResponseX on SearchedFeedsResponse {
  Feeds toEntity() {
    return Feeds(feeds: feeds.toEntity(), nextCursor: nextCursor, totalCount: totalCount);
  }
}
