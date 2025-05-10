import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/data/model/shared/cursor_response.dart';

part 'cursor_and_count_response.freezed.dart';
part 'cursor_and_count_response.g.dart';

@Freezed(copyWith: false)
abstract class CursorAndCountResponse with _$CursorAndCountResponse implements CursorResponse {
  const CursorAndCountResponse._();

  const factory CursorAndCountResponse({String? nextCursor, required int totalCount}) = _CursorAndCountResponse;

  factory CursorAndCountResponse.fromJson(Map<String, dynamic> json) => _$CursorAndCountResponseFromJson(json);
}
