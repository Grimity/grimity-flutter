import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/service/me_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteUserUseCase extends NoParamUseCase<Result<void>> {
  DeleteUserUseCase(this._meService);

  final MeService _meService;

  @override
  Future<Result<void>> execute() async {
    return await _meService.deleteUser();
  }
}
