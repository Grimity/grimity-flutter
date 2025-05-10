import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/repository/feed_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetLatestFeedsUseCase extends UseCase<GetLatestFeedsRequestParam, Result<Feeds>> {
  GetLatestFeedsUseCase(this._feedRepository);

  final FeedRepository _feedRepository;

  @override
  Future<Result<Feeds>> execute(GetLatestFeedsRequestParam request) async {
    return await _feedRepository.getLatestFeeds(request.size, request.cursor);
  }
}

class GetLatestFeedsRequestParam {
  final int? size;
  final String? cursor;

  GetLatestFeedsRequestParam({this.size, this.cursor});
}
