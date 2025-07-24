import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/repository/feed_comments_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UnLikeFeedCommentUseCase extends UseCase<String, Result<void>> {
  UnLikeFeedCommentUseCase(this._feedCommentsRepository);

  final FeedCommentsRepository _feedCommentsRepository;

  @override
  FutureOr<Result<void>> execute(String id) async {
    return await _feedCommentsRepository.unlikeFeedComment(id);
  }
}
