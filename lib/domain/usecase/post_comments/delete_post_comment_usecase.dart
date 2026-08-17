import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/service/post_comments_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeletePostCommentUseCase extends UseCase<String, Result<void>> {
  DeletePostCommentUseCase(this._postCommentsService);

  final PostCommentsService _postCommentsService;

  @override
  FutureOr<Result<void>> execute(String id) async {
    return await _postCommentsService.deletePostComment(id);
  }
}
