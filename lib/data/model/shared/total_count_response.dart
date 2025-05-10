import 'package:freezed_annotation/freezed_annotation.dart';

part 'total_count_response.freezed.dart';
part 'total_count_response.g.dart';

@Freezed(copyWith: false)
abstract class TotalCountResponse with _$TotalCountResponse {
  const TotalCountResponse._();

  const factory TotalCountResponse({required int totalCount}) = _TotalCountResponse;

  factory TotalCountResponse.fromJson(Map<String, dynamic> json) => _$TotalCountResponseFromJson(json);
}
