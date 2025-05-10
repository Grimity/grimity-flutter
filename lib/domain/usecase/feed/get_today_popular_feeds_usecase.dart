import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/repository/feed_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTodayPopularFeedsUseCase extends NoParamUseCase<Result<List<Feed>>> {
  GetTodayPopularFeedsUseCase(this._feedRepository);

  final FeedRepository _feedRepository;

  @override
  Future<Result<List<Feed>>> execute() async {
    return await _feedRepository.getTodayPopularFeeds();
  }
}
