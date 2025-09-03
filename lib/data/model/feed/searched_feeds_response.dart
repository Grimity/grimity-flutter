import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/feed/searched_feed_response.dart';
import 'package:grimity/data/model/shared/cursor_and_count_response.dart'; // 리스트 매핑 확장에 필요
import 'package:grimity/domain/entity/feeds.dart';  // Feeds 엔티티로 매핑

part 'searched_feeds_response.freezed.dart';
part 'searched_feeds_response.g.dart';

@Freezed(copyWith: false)
abstract class SearchedFeedsResponse with _$SearchedFeedsResponse
    implements CursorAndCountResponse {
  const SearchedFeedsResponse._();

  const factory SearchedFeedsResponse({
    String? nextCursor,
    @Default(0) int totalCount,                                  // ✅ required 제거
    @Default(<SearchedFeedResponse>[]) List<SearchedFeedResponse> feeds, // ✅ required 제거
  }) = _SearchedFeedsResponse;

  factory SearchedFeedsResponse.fromJson(Map<String, dynamic> json)
  => _$SearchedFeedsResponseFromJson(json);
}

extension SearchedFeedsResponseX on SearchedFeedsResponse {
  Feeds toEntity() {
    return Feeds(
      feeds: feeds.toEntity(),   // SearchedFeedResponse -> Feed 리스트 매핑
      nextCursor: nextCursor,    // 커서 보존
      totalCount: totalCount,    // 총 개수 보존
    );
  }
}
