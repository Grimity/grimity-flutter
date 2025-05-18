import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/repository/me_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMeUseCase extends NoParamUseCase<Result<User>> {
  GetMeUseCase(this._meRepository);

  final MeRepository _meRepository;

  @override
  Future<Result<User>> execute() async {
    return await _meRepository.getMe();
  }
}
