import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/feeds_request_param.dart';
import 'package:grimity/data/service/feed_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateFeedUseCase extends UseCase<CreateFeedRequest, Result<String>> {
  CreateFeedUseCase(this._feedService);

  final FeedService _feedService;

  @override
  FutureOr<Result<String>> execute(CreateFeedRequest request) async {
    return await _feedService.createFeed(request);
  }
}
