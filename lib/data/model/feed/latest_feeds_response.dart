import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/feed/latest_feed_response.dart';
import 'package:grimity/data/model/shared/cursor_response.dart';
import 'package:grimity/domain/entity/feeds.dart';

part 'latest_feeds_response.freezed.dart';
part 'latest_feeds_response.g.dart';

@Freezed(copyWith: false)
abstract class LatestFeedsResponse with _$LatestFeedsResponse implements CursorResponse {
  const LatestFeedsResponse._();

  const factory LatestFeedsResponse({String? nextCursor, required List<LatestFeedResponse> feeds}) =
      _LatestFeedsResponse;

  factory LatestFeedsResponse.fromJson(Map<String, dynamic> json) => _$LatestFeedsResponseFromJson(json);
}

extension LatestFeedsResponseX on LatestFeedsResponse {
  Feeds toEntity() {
    return Feeds(feeds: feeds.toEntity(), nextCursor: nextCursor);
  }
}
