import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/repository/me_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteUserUseCase extends NoParamUseCase<Result<void>> {
  DeleteUserUseCase(this._meRepository);

  final MeRepository _meRepository;

  @override
  Future<Result<void>> execute() async {
    return await _meRepository.deleteUser();
  }
}
