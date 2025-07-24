import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/repository/feed_comments_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LikeFeedCommentUseCase extends UseCase<String, Result<void>> {
  LikeFeedCommentUseCase(this._feedCommentsRepository);

  final FeedCommentsRepository _feedCommentsRepository;

  @override
  FutureOr<Result<void>> execute(String id) async {
    return await _feedCommentsRepository.likeFeedComment(id);
  }
}
