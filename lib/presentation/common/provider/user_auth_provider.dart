import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/usecase/auth_usecases.dart';
import 'package:grimity/domain/usecase/settings_usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_auth_provider.g.dart';

@Riverpod(keepAlive: true)
class UserAuth extends _$UserAuth {
  @override
  User? build() {
    return null;
  }

  /*
   * 로그인
   * state = User -> 로그인 성공
   * state = null -> 회원가입 필요
   * Exception -> 로그인 실패
   */

  Future<void> login(LoginProvider provider) async {
    final result = await completeLoginProcessUseCase.execute(provider, ref);

    result.fold(
      onSuccess: (data) {
        state = data;
      },
      onFailure: (error) {
        if (error.toString().contains('USER')) {
          state = null;
        } else {
          throw error;
        }
      },
    );
  }

  Future<void> logout(LoginProvider provider) async {
    await logoutWithOAuthUseCase.execute(provider);
    await clearSecureSettingsUseCase.execute();
  }
}
