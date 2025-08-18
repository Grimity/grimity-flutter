import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/comment.dart';
import 'package:grimity/domain/repository/post_comments_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPostCommentsUseCase extends UseCase<String, Result<List<Comment>>> {
  GetPostCommentsUseCase(this._postCommentsRepository);

  final PostCommentsRepository _postCommentsRepository;

  @override
  FutureOr<Result<List<Comment>>> execute(String postId) async {
    return await _postCommentsRepository.getPostComments(postId);
  }
}
