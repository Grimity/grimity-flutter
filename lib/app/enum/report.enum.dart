import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'wire')
enum ReportType {
  impersonation('사칭계정'),
  spam('스팸/도배'),
  abusive('욕설/비방'),
  inappropriateProfile('부적절한 프로필'),
  sexualContent('선정적인 컨텐츠'),
  other('기타');

  final String wire;
  const ReportType(this.wire);

  String get displayName => wire;
}

enum ReportRefType {
  @JsonValue('USER')
  user('USER'),

  @JsonValue('FEED')
  feed('FEED'),

  @JsonValue('FEED_COMMENT')
  feedComment('FEED_COMMENT'),

  @JsonValue('POST')
  post('POST'),

  @JsonValue('POST_COMMENT')
  postComment('POST_COMMENT'),

  @JsonValue('CHAT')
  chat('CHAT');

  final String jsonKey;
  const ReportRefType(this.jsonKey);

  String toJson() => jsonKey;
}
