import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/token.dart';
import 'package:grimity/data/service/auth_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class RefreshTokenUseCase extends NoParamUseCase<Result<Token>> {
  RefreshTokenUseCase(this._authService);

  final AuthService _authService;
  @override
  Future<Result<Token>> execute() async {
    return await _authService.refresh();
  }
}
