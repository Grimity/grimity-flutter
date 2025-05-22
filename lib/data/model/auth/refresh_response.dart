import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/token.dart';

part 'refresh_response.freezed.dart';
part 'refresh_response.g.dart';

@freezed
abstract class RefreshResponse with _$RefreshResponse {
  const factory RefreshResponse({required String accessToken, required String refreshToken}) = _RefreshResponse;

  factory RefreshResponse.fromJson(Map<String, Object?> json) => _$RefreshResponseFromJson(json);
}

extension RefreshResponseX on RefreshResponse {
  Token toToken() {
    return Token(accessToken: accessToken, refreshToken: refreshToken);
  }
}
