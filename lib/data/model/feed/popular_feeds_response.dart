import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/feed/popular_feed_response.dart';
import 'package:grimity/data/model/shared/cursor_response.dart';
import 'package:grimity/domain/entity/feed.dart';

part 'popular_feeds_response.freezed.dart';
part 'popular_feeds_response.g.dart';

@Freezed(copyWith: false)
abstract class PopularFeedsResponse with _$PopularFeedsResponse implements CursorResponse {
  const PopularFeedsResponse._();

  const factory PopularFeedsResponse({String? nextCursor, required List<PopularFeedResponse> feeds}) =
      _PopularFeedsResponse;

  factory PopularFeedsResponse.fromJson(Map<String, dynamic> json) => _$PopularFeedsResponseFromJson(json);
}

extension PopularFeedsResponseX on PopularFeedsResponse {
  List<Feed> toEntity() {
    return feeds.toEntity();
  }
}
