// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'jwt_response.freezed.dart';
part 'jwt_response.g.dart';

@Freezed()
abstract class JwtResponse with _$JwtResponse {
  const factory JwtResponse({
    required String accessToken,
    required String refreshToken,
  }) = _JwtResponse;

  factory JwtResponse.fromJson(Map<String, Object?> json) => _$JwtResponseFromJson(json);
}
