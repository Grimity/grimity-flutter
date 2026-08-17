// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum UploadCommissionWorkResult403ResponseStatus {
  @JsonValue(403)
  value403(403),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const UploadCommissionWorkResult403ResponseStatus(this.json);

  factory UploadCommissionWorkResult403ResponseStatus.fromJson(num json) => values.firstWhere(
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
  static List<UploadCommissionWorkResult403ResponseStatus> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
