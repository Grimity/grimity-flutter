import 'package:freezed_annotation/freezed_annotation.dart';

part 'id_response.freezed.dart';

part 'id_response.g.dart';

@Freezed(copyWith: false)
abstract class IdResponse with _$IdResponse {
  const IdResponse._();

  const factory IdResponse({required String id}) = _IdResponse;

  factory IdResponse.fromJson(Map<String, dynamic> json) => _$IdResponseFromJson(json);
}
