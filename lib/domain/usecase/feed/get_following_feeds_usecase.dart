import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/repository/feed_repository.dart';
import 'package:grimity/domain/usecase/feed_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFollowingFeedsUseCase extends UseCase<GetFollowingFeedsRequestParam, Result<Feeds>> {
  GetFollowingFeedsUseCase(this._feedRepository);

  final FeedRepository _feedRepository;

  @override
  Future<Result<Feeds>> execute(GetFollowingFeedsRequestParam request) async {
    final result = await _feedRepository.getFollowingFeeds(request.size, request.cursor);

    return result.fold(
      onSuccess: (feeds) {
        for (final feed in feeds.feeds) {
          // Feed 조회수 API 비동기 호출.
          incrementFeedViewCountUseCase.execute(feed.id).catchError((error, stack) {
            FirebaseCrashlytics.instance.recordError(
              error,
              stack,
              reason: '피드 조회수 증가 실패',
            );

            return Result.failure(error);
          });
        }

        // 조회수 증가 API 결과에 상관 없이 +1 조회수 응답.
        final incrementViewFeeds = feeds.copyWith(
          feeds: feeds.feeds.map((feed) => feed.copyWith(viewCount: (feed.viewCount ?? 0) + 1)).toList(),
        );

        return Result.success(incrementViewFeeds);
      },
      onFailure: (error) => Result.failure(error),
    );
  }
}

class GetFollowingFeedsRequestParam {
  final int? size;
  final String? cursor;

  GetFollowingFeedsRequestParam({this.size, this.cursor});
}
