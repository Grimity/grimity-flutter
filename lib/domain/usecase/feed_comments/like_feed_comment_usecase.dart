import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/service/feed_comments_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class LikeFeedCommentUseCase extends UseCase<String, Result<void>> {
  LikeFeedCommentUseCase(this._feedCommentsService);

  final FeedCommentsService _feedCommentsService;

  @override
  FutureOr<Result<void>> execute(String id) async {
    return await _feedCommentsService.likeFeedComment(id);
  }
}
