import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/comment.dart';
import 'package:grimity/domain/repository/feed_comments_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFeedCommentsUseCase extends UseCase<String, Result<List<Comment>>> {
  GetFeedCommentsUseCase(this._feedCommentsRepository);

  final FeedCommentsRepository _feedCommentsRepository;

  @override
  FutureOr<Result<List<Comment>>> execute(String feedId) async {
    return await _feedCommentsRepository.getFeedComments(feedId);
  }
}
