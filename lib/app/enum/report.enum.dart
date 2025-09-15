import 'package:json_annotation/json_annotation.dart';

enum ReportType {
  @JsonValue('사칭계정')
  impersonation,
  @JsonValue('스팸/도배')
  spam,
  @JsonValue('욕설/비방')
  abusive,
  @JsonValue('부적절한 프로필')
  inappropriateProfile,
  @JsonValue('선정적인 컨텐츠')
  sexualContent,
  @JsonValue('기타')
  other,
}

enum ReportRefType {
  @JsonValue('USER')
  user,
  @JsonValue('FEED')
  feed,
  @JsonValue('FEED_COMMENT')
  feedComment,
  @JsonValue('POST')
  post,
  @JsonValue('POST_COMMENT')
  postComment,
  @JsonValue('CHAT')
  chat,
}
