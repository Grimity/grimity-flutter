import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/service/feed_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveFeedUseCase extends UseCase<String, Result<void>> {
  SaveFeedUseCase(this._feedService);

  final FeedService _feedService;

  @override
  FutureOr<Result<void>> execute(String id) async {
    return await _feedService.saveFeed(id);
  }
}
