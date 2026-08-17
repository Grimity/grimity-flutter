import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/service/feed_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class IncrementFeedViewCountUseCase extends UseCase<String, Result<void>> {
  IncrementFeedViewCountUseCase(this._feedService);

  final FeedService _feedService;

  @override
  Future<Result<void>> execute(String id) async {
    return await _feedService.incrementFeedViewCount(id);
  }
}
