import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/me_request_params.dart';
import 'package:grimity/domain/repository/me_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateSubscriptionUseCase extends UseCase<UpdateSubscriptionRequestParam, Result<void>> {
  UpdateSubscriptionUseCase(this._meRepository);

  final MeRepository _meRepository;

  @override
  FutureOr<Result<void>> execute(UpdateSubscriptionRequestParam request) async {
    return await _meRepository.updateSubscription(request);
  }
}
