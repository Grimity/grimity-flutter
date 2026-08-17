// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

/// 신고 대상 타입
@JsonEnum()
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
  chat('CHAT'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const ReportRefType(this.json);

  factory ReportRefType.fromJson(String json) => values.firstWhere(
    (e) => e.json == json,
    orElse: () => $unknown,
  );

  final String? json;
  String toJson() {
    final value = json;
    if (value == null) {
      throw StateError(
        'Cannot convert enum value with null JSON representation to String. '
        'This usually happens for \$unknown or @JsonValue(null) entries.',
      );
    }
    return value as String;
  }

  @override
  String toString() => json?.toString() ?? super.toString();

  /// Returns all defined enum values excluding the $unknown value.
  static List<ReportRefType> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
