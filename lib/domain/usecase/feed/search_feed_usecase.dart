import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/feeds_request_param.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/repository/feed_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchFeedUseCase extends UseCase<SearchFeedRequest, Result<Feeds>> {
  SearchFeedUseCase(this._feedRepository);

  final FeedRepository _feedRepository;

  @override
  Future<Result<Feeds>> execute(SearchFeedRequest request) async {
    return await _feedRepository.searchFeeds(request);
  }
}
