import 'package:json_annotation/json_annotation.dart';

enum SubscriptionType {
  @JsonValue('FOLLOW')
  follow('FOLLOW'),

  @JsonValue('FEED_LIKE')
  feedLike('FEED_LIKE'),

  @JsonValue('FEED_COMMENT')
  feedComment('FEED_COMMENT'),

  @JsonValue('FEED_REPLY')
  feedReply('FEED_REPLY'),

  @JsonValue('POST_COMMENT')
  postComment('POST_COMMENT'),

  @JsonValue('POST_REPLY')
  postReply('POST_REPLY');

  final String jsonKey;
  const SubscriptionType(this.jsonKey);

  String toJson() => jsonKey;
}
