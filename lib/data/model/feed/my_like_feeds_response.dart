import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/feed/my_like_feed_response.dart';
import 'package:grimity/data/model/shared/cursor_response.dart';
import 'package:grimity/domain/entity/feed.dart';

part 'my_like_feeds_response.freezed.dart';
part 'my_like_feeds_response.g.dart';

@Freezed(copyWith: false)
abstract class MyLikeFeedsResponse with _$MyLikeFeedsResponse implements CursorResponse {
  const MyLikeFeedsResponse._();

  const factory MyLikeFeedsResponse({String? nextCursor, required List<MyLikeFeedResponse> feeds}) =
      _MyLikeFeedsResponse;

  factory MyLikeFeedsResponse.fromJson(Map<String, dynamic> json) => _$MyLikeFeedsResponseFromJson(json);
}

extension MyLikeFeedsResponseX on MyLikeFeedsResponse {
  List<Feed> toEntity() {
    return feeds.toEntity();
  }
}
