import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/app/util/device_info_util.dart';
import 'package:grimity/domain/entity/token.dart';
import 'package:grimity/domain/repository/auth_repository.dart';
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

class LoginRequestParam {
  final String provider;
  final String providerAccessToken;

  LoginRequestParam({required this.provider, required this.providerAccessToken});

  Map<String, dynamic> toJson() {
    return {'provider': provider, 'providerAccessToken': providerAccessToken};
  }
}
