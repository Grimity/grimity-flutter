import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/token.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({required String id, required String accessToken, required String refreshToken}) =
      _LoginResponse;

  factory LoginResponse.fromJson(Map<String, Object?> json) => _$LoginResponseFromJson(json);
}

extension LoginResponseX on LoginResponse {
  Token toToken() {
    return Token(accessToken: accessToken, refreshToken: refreshToken);
  }
}
