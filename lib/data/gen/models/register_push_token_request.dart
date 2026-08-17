// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_push_token_request.freezed.dart';
part 'register_push_token_request.g.dart';

@Freezed()
abstract class RegisterPushTokenRequest with _$RegisterPushTokenRequest {
  const factory RegisterPushTokenRequest({
    required String deviceId,
    required String token,
  }) = _RegisterPushTokenRequest;

  factory RegisterPushTokenRequest.fromJson(Map<String, Object?> json) => _$RegisterPushTokenRequestFromJson(json);
}
