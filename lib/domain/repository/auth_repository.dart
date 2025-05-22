import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/domain/dto/auth_request_params.dart';
import 'package:grimity/domain/entity/token.dart';

abstract class AuthRepository {
  Future<Result<Token>> login(LoginRequestParam request);
  Future<Result<String>> loginWithOAuth(LoginProvider provider);
  Future<Result<Token>> register(RegisterRequestParam request);
  Future<Result<Token>> refresh();
  Future<Result<void>> logout();
  Future<Result<void>> logoutWithOAuth(LoginProvider provider);
}
