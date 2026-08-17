import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/service/me_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteBackgroundImageUseCase extends NoParamUseCase<Result<void>> {
  DeleteBackgroundImageUseCase(this._meService);

  final MeService _meService;

  @override
  Future<Result<void>> execute() async {
    return await _meService.deleteBackgroundImage();
  }
}
