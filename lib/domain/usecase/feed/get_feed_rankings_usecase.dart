import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/feeds_request_param.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/data/service/feed_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFeedRankingsUseCase extends UseCase<GetFeedRankingsRequest, Result<List<Feed>>> {
  GetFeedRankingsUseCase(this._feedService);

  final FeedService _feedService;

  @override
  FutureOr<Result<List<Feed>>> execute(GetFeedRankingsRequest request) async {
    return await _feedService.getFeedRankings(
      month: request.month,
      startDate: request.startDate,
      endDate: request.endDate,
    );
  }
}
