import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/token.dart';
import 'package:grimity/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RefreshTokenUseCase extends NoParamUseCase<Result<Token>> {
  RefreshTokenUseCase(this._authRepository);

  final AuthRepository _authRepository;
  @override
  Future<Result<Token>> execute() async {
    return await _authRepository.refresh();
  }
}
