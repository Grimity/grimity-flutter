import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/data/service/me_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMeUseCase extends NoParamUseCase<Result<User>> {
  GetMeUseCase(this._meService);

  final MeService _meService;

  @override
  Future<Result<User>> execute() async {
    return await _meService.getMe();
  }
}
