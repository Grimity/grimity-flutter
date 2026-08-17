import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/subscription.dart';
import 'package:grimity/data/service/me_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSubscriptionUseCase extends NoParamUseCase<Result<Subscription>> {
  GetSubscriptionUseCase(this._meService);

  final MeService _meService;

  @override
  FutureOr<Result<Subscription>> execute() async {
    return await _meService.getSubscription();
  }
}
