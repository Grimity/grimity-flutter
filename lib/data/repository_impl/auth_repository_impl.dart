import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/data_source/remote/auth_api.dart';
import 'package:grimity/data/model/login_response.dart';
import 'package:grimity/domain/entity/token.dart';
import 'package:grimity/domain/repository/auth_repository.dart';
import 'package:grimity/domain/usecase/auth/login_usecase.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository {
  final AuthAPI _authAPI;

  AuthRepositoryImpl(this._authAPI);

  @override
  Future<Result<Token>> login(LoginRequestParam request) async {
    try {
      final LoginResponse response = await _authAPI.login(request);
      return Result.success(response.toToken());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
