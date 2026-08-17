import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/feeds_request_param.dart';
import 'package:grimity/data/service/feed_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteFeedsUseCase extends UseCase<DeleteFeedsRequest, Result<void>> {
  DeleteFeedsUseCase(this._feedService);

  final FeedService _feedService;

  @override
  FutureOr<Result<void>> execute(DeleteFeedsRequest request) async {
    return await _feedService.deleteFeeds(request);
  }
}
