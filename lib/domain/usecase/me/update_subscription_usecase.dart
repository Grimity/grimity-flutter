import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/me_request_params.dart';
import 'package:grimity/data/service/me_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateSubscriptionUseCase extends UseCase<UpdateSubscriptionRequestParam, Result<void>> {
  UpdateSubscriptionUseCase(this._meService);

  final MeService _meService;

  @override
  FutureOr<Result<void>> execute(UpdateSubscriptionRequestParam request) async {
    return await _meService.updateSubscription(request);
  }
}
