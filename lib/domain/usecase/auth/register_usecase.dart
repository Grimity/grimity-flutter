import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/auth_request_params.dart';
import 'package:grimity/domain/entity/token.dart';
import 'package:grimity/data/service/auth_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterUseCase extends UseCase<RegisterRequestParam, Result<void>> {
  RegisterUseCase(this._authService);

  final AuthService _authService;
  @override
  Future<Result<Token>> execute(RegisterRequestParam param) async {
    return await _authService.register(param);
  }
}
