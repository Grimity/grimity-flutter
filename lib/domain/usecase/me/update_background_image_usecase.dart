import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/me_request_params.dart';
import 'package:grimity/domain/repository/me_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateBackgroundImageUseCase extends UseCase<UpdateBackgroundImageRequestParam, Result<void>> {
  UpdateBackgroundImageUseCase(this._meRepository);

  final MeRepository _meRepository;

  @override
  Future<Result<void>> execute(UpdateBackgroundImageRequestParam request) async {
    return await _meRepository.updateBackgroundImage(request);
  }
}
