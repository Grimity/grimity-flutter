import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/service/auth_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutUseCase extends NoParamUseCase<Result<void>> {
  LogoutUseCase(this._authService);

  final AuthService _authService;
  @override
  Future<Result<void>> execute() async {
    return await _authService.logout();
  }
}
