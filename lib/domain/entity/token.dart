import 'package:freezed_annotation/freezed_annotation.dart';

part 'token.freezed.dart';
part 'token.g.dart';

@freezed
abstract class Token with _$Token {
  const factory Token({required String accessToken, required String refreshToken, required String id}) = _Token;

  factory Token.fromJson(Map<String, Object?> json) => _$TokenFromJson(json);
}
