// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'update_profile_conflict_response_message.dart';
import 'update_profile_conflict_response_status_code.dart';

part 'update_profile_conflict_response.freezed.dart';
part 'update_profile_conflict_response.g.dart';

@Freezed()
abstract class UpdateProfileConflictResponse with _$UpdateProfileConflictResponse {
  const factory UpdateProfileConflictResponse({
    required UpdateProfileConflictResponseStatusCode statusCode,
    required UpdateProfileConflictResponseMessage message,
  }) = _UpdateProfileConflictResponse;

  factory UpdateProfileConflictResponse.fromJson(Map<String, Object?> json) =>
      _$UpdateProfileConflictResponseFromJson(json);
}
