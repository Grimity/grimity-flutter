import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/repository/feed_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteFeedUseCase extends UseCase<String, Result<void>> {
  DeleteFeedUseCase(this._feedRepository);

  final FeedRepository _feedRepository;

  @override
  FutureOr<Result<void>> execute(String id) async {
    return await _feedRepository.deleteFeed(id);
  }
}
