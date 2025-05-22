import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutUseCase extends NoParamUseCase<Result<void>> {
  LogoutUseCase(this._authRepository);

  final AuthRepository _authRepository;
  @override
  Future<Result<void>> execute() async {
    return await _authRepository.logout();
  }
}
