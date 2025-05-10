import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/feed/following_feed_response.dart';
import 'package:grimity/data/model/shared/cursor_response.dart';
import 'package:grimity/domain/entity/feed.dart';

part 'following_feeds_response.freezed.dart';
part 'following_feeds_response.g.dart';

@Freezed(copyWith: false)
abstract class FollowingFeedsResponse with _$FollowingFeedsResponse implements CursorResponse {
  const FollowingFeedsResponse._();

  const factory FollowingFeedsResponse({String? nextCursor, required List<FollowingFeedResponse> feeds}) =
      _FollowingFeedsResponse;

  factory FollowingFeedsResponse.fromJson(Map<String, dynamic> json) => _$FollowingFeedsResponseFromJson(json);
}

extension FollowingFeedsResponseX on FollowingFeedsResponse {
  List<Feed> toEntity() {
    return feeds.toEntity();
  }
}
