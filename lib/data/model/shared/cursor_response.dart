import 'package:freezed_annotation/freezed_annotation.dart';

part 'cursor_response.freezed.dart';
part 'cursor_response.g.dart';

@Freezed(copyWith: false)
abstract class CursorResponse with _$CursorResponse {
  const CursorResponse._();

  const factory CursorResponse({String? nextCursor}) = _CursorResponse;

  factory CursorResponse.fromJson(Map<String, dynamic> json) => _$CursorResponseFromJson(json);
}
