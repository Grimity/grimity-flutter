import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/auth_request_params.dart';
import 'package:grimity/domain/entity/token.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/repository/auth_repository.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:grimity/domain/usecase/auth_usecases.dart';
import 'package:grimity/presentation/common/provider/auth_credential_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';

@injectable
class CompleteRegisterUseCase extends ParamWithRefUseCase<RegisterRequestParam, Result<User>> {
  CompleteRegisterUseCase(this._authRepository);

  final AuthRepository _authRepository;
  @override
  Future<Result<User>> execute(RegisterRequestParam param, Ref ref) async {
    // 회원가입 시도
    final Result<Token> registerResult = await _authRepository.register(param);

    if (registerResult.isFailure) {
      return Result.failure(registerResult.error);
    }

    // 회원가입 성공 시 SecureStorage에 토큰 저장
    final token = registerResult.data;
    await updateTokenUseCase.execute(token);

    // User 정보 조회
    final user = await getMeUseCase.execute();
    if (user.isFailure) {
      return Result.failure(user.error);
    }

    // Dispose AuthCredentialProvider
    ref.read(authCredentialProvider.notifier).clear();

    return Result.success(user.data);
  }
}
