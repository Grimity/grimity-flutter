// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'auth_provider.dart';

part 'register_request.freezed.dart';
part 'register_request.g.dart';

@Freezed()
abstract class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    /// 대소문자 구분 X
    required AuthProvider provider,
    required String providerAccessToken,
    required String name,

    /// 디바이스 ID, 앱에서만 씁니다
    String? deviceId,

    /// id필드말고 url 필드를 써주세요
    String? url,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, Object?> json) => _$RegisterRequestFromJson(json);
}
