import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_profile_conflict_response.freezed.dart';
part 'update_profile_conflict_response.g.dart';

@Freezed(copyWith: false)
abstract class UpdateProfileConflictResponse with _$UpdateProfileConflictResponse {
  const factory UpdateProfileConflictResponse({required String message}) = _UpdateProfileConflictResponse;

  factory UpdateProfileConflictResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileConflictResponseFromJson(json);
}
