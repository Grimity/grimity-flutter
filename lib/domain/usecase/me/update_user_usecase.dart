import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/me_request_params.dart';
import 'package:grimity/domain/repository/me_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateUserUseCase extends UseCase<UpdateUserRequest, Result<void>> {
  UpdateUserUseCase(this._meRepository);

  final MeRepository _meRepository;

  @override
  Future<Result<void>> execute(UpdateUserRequest request) async {
    return await _meRepository.updateUser(request);
  }
}
