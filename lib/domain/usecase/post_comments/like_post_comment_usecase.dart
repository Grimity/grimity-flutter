import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/repository/post_comments_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LikePostCommentUseCase extends UseCase<String, Result<void>> {
  LikePostCommentUseCase(this._postCommentsRepository);

  final PostCommentsRepository _postCommentsRepository;

  @override
  FutureOr<Result<void>> execute(String id) async {
    return await _postCommentsRepository.likePostComment(id);
  }
}
