import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/feed/user_feed_response.dart';
import 'package:grimity/data/model/shared/cursor_response.dart';
import 'package:grimity/domain/entity/feed.dart';

part 'user_feeds_response.freezed.dart';
part 'user_feeds_response.g.dart';

@Freezed(copyWith: false)
abstract class UserFeedsResponse with _$UserFeedsResponse implements CursorResponse {
  const UserFeedsResponse._();

  const factory UserFeedsResponse({String? nextCursor, required List<UserFeedResponse> feeds}) = _UserFeedsResponse;

  factory UserFeedsResponse.fromJson(Map<String, dynamic> json) => _$UserFeedsResponseFromJson(json);
}

extension UserFeedsResponseX on UserFeedsResponse {
  List<Feed> toEntity() {
    return feeds.toEntity();
  }
}
