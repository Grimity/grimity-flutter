// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum VerifyIdentity409ResponseErrorCode {
  @JsonValue('CI_MISMATCH')
  ciMismatch('CI_MISMATCH'),
  @JsonValue('CI_TAKEN')
  ciTaken('CI_TAKEN'),
  @JsonValue('ID_REUSED')
  idReused('ID_REUSED'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const VerifyIdentity409ResponseErrorCode(this.json);

  factory VerifyIdentity409ResponseErrorCode.fromJson(String json) => values.firstWhere(
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
  static List<VerifyIdentity409ResponseErrorCode> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
