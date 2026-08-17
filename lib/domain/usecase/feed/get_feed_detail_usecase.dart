import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/data/service/feed_service.dart';
import 'package:grimity/domain/usecase/feed_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFeedDetailUseCase extends UseCase<String, Result<Feed>> {
  GetFeedDetailUseCase(this._feedService);

  final FeedService _feedService;

  @override
  FutureOr<Result<Feed>> execute(String id) async {
    final result = await _feedService.getFeedDetail(id);

    return result.fold(
      onSuccess: (feed) {
        // Feed 조회수 API 비동기 호출.
        incrementFeedViewCountUseCase.execute(id).catchError((error, stack) {
          FirebaseCrashlytics.instance.recordError(
            error,
            stack,
            reason: '피드 조회수 증가 실패',
          );

          return Result.failure(error);
        });

        // 조회수 증가 API 결과에 상관 없이 +1 조회수 응답.
        return Result.success(
          feed.copyWith(viewCount: (feed.viewCount ?? 0) + 1),
        );
      },
      onFailure: (error) => Result.failure(error),
    );
  }
}
