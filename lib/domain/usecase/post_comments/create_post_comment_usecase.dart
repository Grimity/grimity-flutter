import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/post_comments_request_params.dart';
import 'package:grimity/data/service/post_comments_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreatePostCommentUseCase extends UseCase<CreatePostCommentRequest, Result<void>> {
  CreatePostCommentUseCase(this._postCommentsService);

  final PostCommentsService _postCommentsService;

  @override
  FutureOr<Result<void>> execute(CreatePostCommentRequest request) async {
    return await _postCommentsService.createPostComment(request);
  }
}
