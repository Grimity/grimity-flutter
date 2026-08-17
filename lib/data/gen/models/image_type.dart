// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

/// 대소문자 구분 없습니다
@JsonEnum()
enum ImageType {
  @JsonValue('profile')
  profile('profile'),
  @JsonValue('feed')
  feed('feed'),
  @JsonValue('background')
  background('background'),
  @JsonValue('post')
  post('post'),
  @JsonValue('chat')
  chat('chat'),
  @JsonValue('commission')
  commission('commission'),
  @JsonValue('commission-reference')
  commissionReference('commission-reference'),
  @JsonValue('commission-answer')
  commissionAnswer('commission-answer'),
  @JsonValue('commission-work')
  commissionWork('commission-work'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const ImageType(this.json);

  factory ImageType.fromJson(String json) => values.firstWhere(
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
  static List<ImageType> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
