import 'package:freezed_annotation/freezed_annotation.dart';

part 'conflict_response.freezed.dart';
part 'conflict_response.g.dart';

@Freezed(copyWith: false)
abstract class ConflictResponse with _$ConflictResponse {
  const ConflictResponse._();

  const factory ConflictResponse({required int statusCode}) = _ConflictResponse;

  factory ConflictResponse.fromJson(Map<String, dynamic> json) => _$ConflictResponseFromJson(json);
}
