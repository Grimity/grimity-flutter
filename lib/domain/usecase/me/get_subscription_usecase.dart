import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/subscription.dart';
import 'package:grimity/domain/repository/me_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSubscriptionUseCase extends NoParamUseCase<Result<Subscription>> {
  GetSubscriptionUseCase(this._meRepository);

  final MeRepository _meRepository;

  @override
  FutureOr<Result<Subscription>> execute() async {
    return await _meRepository.getSubscription();
  }
}
