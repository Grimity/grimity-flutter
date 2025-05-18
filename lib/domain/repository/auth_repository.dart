import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/domain/entity/token.dart';
import 'package:grimity/domain/usecase/auth_usecases.dart';

abstract class AuthRepository {
  Future<Result<Token>> login(LoginRequestParam request, String appModel);
  Future<Result<String>> loginWithOAuth(LoginProvider provider);
  Future<Result<void>> logoutWithOAuth(LoginProvider provider);
}
