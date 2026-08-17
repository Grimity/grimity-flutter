import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/me_request_params.dart';
import 'package:grimity/data/service/me_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateBackgroundImageUseCase extends UseCase<UpdateBackgroundImageRequestParam, Result<void>> {
  UpdateBackgroundImageUseCase(this._meService);

  final MeService _meService;

  @override
  Future<Result<void>> execute(UpdateBackgroundImageRequestParam request) async {
    return await _meService.updateBackgroundImage(request);
  }
}
