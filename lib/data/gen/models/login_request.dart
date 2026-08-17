// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'auth_provider.dart';

part 'login_request.freezed.dart';
part 'login_request.g.dart';

@Freezed()
abstract class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    /// 대소문자 구분 X
    required AuthProvider provider,
    required String providerAccessToken,

    /// 디바이스 ID, 앱에서만 씁니다
    String? deviceId,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, Object?> json) => _$LoginRequestFromJson(json);
}
