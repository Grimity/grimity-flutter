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

    if (result.isSuccess) {
      for (final feed in result.data.feeds) {
        incrementFeedViewCountUseCase.execute(feed.id);
      }
    }

    return result;
  }
}

class GetFollowingFeedsRequestParam {
  final int? size;
  final String? cursor;

  GetFollowingFeedsRequestParam({this.size, this.cursor});
}
