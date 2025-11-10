import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_request_params.freezed.dart';

part 'auth_request_params.g.dart';

@freezed
abstract class LoginRequestParam with _$LoginRequestParam {
  const factory LoginRequestParam({
    required String provider,
    required String providerAccessToken,
    required String deviceId,
  }) = _LoginRequestParam;

  factory LoginRequestParam.fromJson(Map<String, dynamic> json) => _$LoginRequestParamFromJson(json);
}

@freezed
abstract class RegisterRequestParam with _$RegisterRequestParam {
  const factory RegisterRequestParam({
    required String provider,
    required String providerAccessToken,
    required String deviceId,
    required String name,
    required String url,
  }) = _RegisterRequestParam;

  factory RegisterRequestParam.fromJson(Map<String, dynamic> json) => _$RegisterRequestParamFromJson(json);
}
