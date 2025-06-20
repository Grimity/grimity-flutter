import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/usecase/auth_usecases.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_auth_provider.g.dart';

@Riverpod(keepAlive: true)
class UserAuth extends _$UserAuth {
  @override
  User? build() {
    return null;
  }

  /*
   * 유저 정보 조회
   * state = User -> 유저 정보 조회 성공
   * state = null -> 유저 정보 조회 실패
   */
  Future<void> getUser() async {
    final result = await getMeUseCase.execute();

    result.fold(
      onSuccess: (data) {
        state = data;
      },
      onFailure: (error) {
        state = null;
      },
    );
  }

  /*
   * 유저 정보 업데이트
   * state = User -> 유저 정보 업데이트 성공
   */
  Future<void> setUser(User user) async {
    state = user;
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

  /*
   * 로그아웃
   * OAuth 로그아웃 / 저장된 토큰 제거
   */
  Future<void> logout(LoginProvider provider) async {
    await completeLogoutProcessUseCase.execute(provider);
    state = null;
  }
}
