import 'package:freezed_annotation/freezed_annotation.dart';

enum PostType {
  @JsonValue('NORMAL')
  normal,
  @JsonValue('QUESTION')
  question,
  @JsonValue('FEEDBACK')
  feedback,
  @JsonValue('NOTICE')
  notice,
  @JsonValue('ALL')
  all,
}
