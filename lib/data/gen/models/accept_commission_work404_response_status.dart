// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum AcceptCommissionWork404ResponseStatus {
  @JsonValue(404)
  value404(404),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const AcceptCommissionWork404ResponseStatus(this.json);

  factory AcceptCommissionWork404ResponseStatus.fromJson(num json) => values.firstWhere(
    (e) => e.json == json,
    orElse: () => $unknown,
  );

  final num? json;
  num toJson() {
    final value = json;
    if (value == null) {
      throw StateError(
        'Cannot convert enum value with null JSON representation to num. '
        'This usually happens for \$unknown or @JsonValue(null) entries.',
      );
    }
    return value as num;
  }

  @override
  String toString() => json?.toString() ?? super.toString();

  /// Returns all defined enum values excluding the $unknown value.
  static List<AcceptCommissionWork404ResponseStatus> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
