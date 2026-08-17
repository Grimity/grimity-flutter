import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/feeds_request_param.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/data/service/feed_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchFeedUseCase extends UseCase<SearchFeedRequest, Result<Feeds>> {
  SearchFeedUseCase(this._feedService);

  final FeedService _feedService;

  @override
  Future<Result<Feeds>> execute(SearchFeedRequest request) async {
    return await _feedService.searchFeeds(request);
  }
}
