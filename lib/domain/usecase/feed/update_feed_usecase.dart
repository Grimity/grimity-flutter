import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/feeds_request_param.dart';
import 'package:grimity/data/service/feed_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateFeedUseCase extends UseCase<UpdateFeedUseCaseParam, Result<void>> {
  UpdateFeedUseCase(this._feedService);

  final FeedService _feedService;

  @override
  FutureOr<Result<void>> execute(UpdateFeedUseCaseParam param) async {
    return await _feedService.updateFeed(param.id, param.request);
  }
}
