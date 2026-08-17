// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

/// DIRECT 모드 필수. FORM 모드면 서버가 무시.
@JsonEnum()
enum CommissionAnswerItemType {
  @JsonValue('TEXT')
  text('TEXT'),
  @JsonValue('SINGLE_SELECT')
  singleSelect('SINGLE_SELECT'),
  @JsonValue('MULTI_SELECT')
  multiSelect('MULTI_SELECT'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const CommissionAnswerItemType(this.json);

  factory CommissionAnswerItemType.fromJson(String json) => values.firstWhere(
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
  static List<CommissionAnswerItemType> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
