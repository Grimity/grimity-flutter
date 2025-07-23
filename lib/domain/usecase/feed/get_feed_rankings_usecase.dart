import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/feeds_request_param.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/repository/feed_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFeedRankingsUseCase extends UseCase<GetFeedRankingsRequest, Result<List<Feed>>> {
  GetFeedRankingsUseCase(this._feedRepository);

  final FeedRepository _feedRepository;

  @override
  FutureOr<Result<List<Feed>>> execute(GetFeedRankingsRequest request) async {
    return await _feedRepository.getFeedRankings(
      month: request.month,
      startDate: request.startDate,
      endDate: request.endDate,
    );
  }
}
