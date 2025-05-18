import 'package:freezed_annotation/freezed_annotation.dart';

enum SubscriptionType {
  @JsonValue('FOLLOW')
  follow,
  @JsonValue('FEED_LIKE')
  feedLike,
  @JsonValue('FEED_COMMENT')
  feedComment,
  @JsonValue('FEED_REPLY')
  feedReply,
  @JsonValue('POST_COMMENT')
  postComment,
  @JsonValue('POST_REPLY')
  postReply,
}
