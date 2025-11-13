import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/repository/feed_repository.dart';
import 'package:grimity/domain/usecase/feed_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFeedDetailUseCase extends UseCase<String, Result<Feed>> {
  GetFeedDetailUseCase(this._feedRepository);

  final FeedRepository _feedRepository;

  @override
  FutureOr<Result<Feed>> execute(String id) async {
    final result = await _feedRepository.getFeedDetail(id);

    if (result.isSuccess) {
      incrementFeedViewCountUseCase.execute(id);
    }

    return result;
  }
}
