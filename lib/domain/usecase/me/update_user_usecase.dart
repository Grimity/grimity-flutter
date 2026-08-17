import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/me_request_params.dart';
import 'package:grimity/data/service/me_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateUserUseCase extends UseCase<UpdateUserRequest, Result<void>> {
  UpdateUserUseCase(this._meService);

  final MeService _meService;

  @override
  Future<Result<void>> execute(UpdateUserRequest request) async {
    return await _meService.updateUser(request);
  }
}
