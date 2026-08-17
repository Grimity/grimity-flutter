// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

/// 메시지 타입 (USER: 일반, COMMISSION_*: 시스템 메시지)
@JsonEnum()
enum ChatMessageType {
  @JsonValue('USER')
  user('USER'),
  @JsonValue('COMMISSION_REQUESTED')
  commissionRequested('COMMISSION_REQUESTED'),
  @JsonValue('COMMISSION_ACCEPTED')
  commissionAccepted('COMMISSION_ACCEPTED'),
  @JsonValue('COMMISSION_REJECTED')
  commissionRejected('COMMISSION_REJECTED'),
  @JsonValue('COMMISSION_CANCELED')
  commissionCanceled('COMMISSION_CANCELED'),
  @JsonValue('COMMISSION_RESULT_UPLOADED')
  commissionResultUploaded('COMMISSION_RESULT_UPLOADED'),
  @JsonValue('COMMISSION_FINAL_UPLOADED')
  commissionFinalUploaded('COMMISSION_FINAL_UPLOADED'),
  @JsonValue('COMMISSION_COMPLETED')
  commissionCompleted('COMMISSION_COMPLETED'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const ChatMessageType(this.json);

  factory ChatMessageType.fromJson(String json) => values.firstWhere(
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
  static List<ChatMessageType> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
