// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_identity_request.freezed.dart';
part 'verify_identity_request.g.dart';

@Freezed()
abstract class VerifyIdentityRequest with _$VerifyIdentityRequest {
  const factory VerifyIdentityRequest({
    /// 포트원 SDK에서 받은 identityVerificationId
    required String identityVerificationId,
  }) = _VerifyIdentityRequest;

  factory VerifyIdentityRequest.fromJson(Map<String, Object?> json) => _$VerifyIdentityRequestFromJson(json);
}
