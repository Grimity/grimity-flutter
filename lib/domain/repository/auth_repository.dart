import 'package:grimity/app/base/result.dart';
import 'package:grimity/domain/entity/token.dart';
import 'package:grimity/domain/usecase/auth/login_usecase.dart';

abstract class AuthRepository {
  Future<Result<Token>> login(LoginRequestParam request);
}
