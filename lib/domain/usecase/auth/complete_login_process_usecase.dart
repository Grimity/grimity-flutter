// lib/domain/usecase/auth/complete_login_process_usecase.dart
import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/usecase/auth_usecases.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class CompleteLoginProcessUseCase extends UseCase<LoginProvider, Result<void>> {
  CompleteLoginProcessUseCase();

  @override
  Future<Result<User>> execute(LoginProvider provider) async {
    try {
      // OAuth로부터 AccessToken 발급
      final Result<String> oauthAccessToken = await loginWithOAuthUseCase.execute(provider);

      if (oauthAccessToken.isFailure) {
        return Result.failure(oauthAccessToken.error);
      }

      // 발급된 AccessToken으로 Grimity 로그인
      final param = LoginRequestParam(provider: provider.name, providerAccessToken: oauthAccessToken.data);
      final loginResult = await loginUseCase.execute(param);

      if (loginResult.isFailure) {
        return Result.failure(loginResult.error);
      }

      // 로그인 성공 시 SecureStorage에 토큰 저장
      final token = loginResult.data;
      await updateTokenUseCase.execute(token);

      // User 정보 조회
      final user = await getMeUseCase.execute();
      if (user.isFailure) {
        return Result.failure(user.error);
      }

      return Result.success(user.data);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
