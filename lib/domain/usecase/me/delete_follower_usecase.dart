import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/service/me_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteFollowerByIdUseCase extends UseCase<String, Result<void>> {
  DeleteFollowerByIdUseCase(this._meService);

  final MeService _meService;

  @override
  FutureOr<Result<void>> execute(String id) async {
    return await _meService.deleteFollowerById(id);
  }
}
