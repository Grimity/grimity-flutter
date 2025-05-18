import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/app/util/device_info_util.dart';
import 'package:grimity/domain/entity/token.dart';
import 'package:grimity/domain/repository/auth_repository.dart';
import 'package:grimity/domain/usecase/auth_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase extends UseCase<LoginRequestParam, Result<Token>> {
  LoginUseCase(this._authRepository);

  final AuthRepository _authRepository;
  @override
  Future<Result<Token>> execute(LoginRequestParam param) async {
    final deviceInfo = await DeviceInfoUtil.getDeviceInfo();

    return await _authRepository.login(param, deviceInfo['model']);
  }
}
