import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
      incrementFeedViewCountUseCase.execute(id).catchError((error, stack) {
        FirebaseCrashlytics.instance.recordError(
          error,
          stack,
          reason: '피드 조회수 증가 실패',
        );

        return Result.failure(error);
      });
    }

    return result;
  }
}
