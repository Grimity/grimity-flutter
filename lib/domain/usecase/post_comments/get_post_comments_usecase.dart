import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/comment.dart';
import 'package:grimity/data/service/post_comments_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPostCommentsUseCase extends UseCase<String, Result<List<Comment>>> {
  GetPostCommentsUseCase(this._postCommentsService);

  final PostCommentsService _postCommentsService;

  @override
  FutureOr<Result<List<Comment>>> execute(String postId) async {
    return await _postCommentsService.getPostComments(postId);
  }
}
