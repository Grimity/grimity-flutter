import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/repository/me_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteBackgroundImageUseCase extends NoParamUseCase<Result<void>> {
  DeleteBackgroundImageUseCase(this._meRepository);

  final MeRepository _meRepository;

  @override
  Future<Result<void>> execute() async {
    return await _meRepository.deleteBackgroundImage();
  }
}
