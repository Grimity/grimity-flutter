// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

/// 신고 타입
@JsonEnum()
enum ReportType {
  /// Incorrect name has been replaced. Original name: `사칭계정`.
  @JsonValue('사칭계정')
  undefined0('사칭계정'),

  /// Incorrect name has been replaced. Original name: `스팸/도배`.
  @JsonValue('스팸/도배')
  undefined1('스팸/도배'),

  /// Incorrect name has been replaced. Original name: `욕설/비방`.
  @JsonValue('욕설/비방')
  undefined2('욕설/비방'),

  /// Incorrect name has been replaced. Original name: `부적절한 프로필`.
  @JsonValue('부적절한 프로필')
  undefined3('부적절한 프로필'),

  /// Incorrect name has been replaced. Original name: `선정적인 컨텐츠`.
  @JsonValue('선정적인 컨텐츠')
  undefined4('선정적인 컨텐츠'),

  /// Incorrect name has been replaced. Original name: `기타`.
  @JsonValue('기타')
  undefined5('기타'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const ReportType(this.json);

  factory ReportType.fromJson(String json) => values.firstWhere(
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
  static List<ReportType> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
