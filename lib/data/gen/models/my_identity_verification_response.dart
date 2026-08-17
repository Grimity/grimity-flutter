// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_identity_verification_response.freezed.dart';
part 'my_identity_verification_response.g.dart';

@Freezed()
abstract class MyIdentityVerificationResponse with _$MyIdentityVerificationResponse {
  const factory MyIdentityVerificationResponse({
    required bool isVerified,
    required String? name,

    /// YYYY-MM-DD 형식, 미인증 시 null
    required String? birthDate,
  }) = _MyIdentityVerificationResponse;

  factory MyIdentityVerificationResponse.fromJson(Map<String, Object?> json) =>
      _$MyIdentityVerificationResponseFromJson(json);
}
