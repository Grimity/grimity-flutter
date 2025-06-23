import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/repository/me_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteFollowerByIdUseCase extends UseCase<String, Result<void>> {
  DeleteFollowerByIdUseCase(this._meRepository);

  final MeRepository _meRepository;

  @override
  FutureOr<Result<void>> execute(String id) async {
    return await _meRepository.deleteFollowerById(id);
  }
}
