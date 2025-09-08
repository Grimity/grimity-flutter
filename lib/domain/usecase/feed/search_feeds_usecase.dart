import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/search_feeds_param.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/repository/feed_repository.dart';

@injectable
class SearchFeedsUseCase extends UseCase<SearchFeedsParam, Result<Feeds>> {
  SearchFeedsUseCase(this._repo);
  final FeedRepository _repo;

  @override
  FutureOr<Result<Feeds>> execute(SearchFeedsParam input) {
    return _repo.searchFeeds(input);
  }
}
