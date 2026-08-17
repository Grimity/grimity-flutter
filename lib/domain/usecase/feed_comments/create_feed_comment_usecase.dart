import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/feed_comments_request_params.dart';
import 'package:grimity/data/service/feed_comments_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateFeedCommentUseCase extends UseCase<CreateFeedCommentRequest, Result<void>> {
  CreateFeedCommentUseCase(this._feedCommentsService);

  final FeedCommentsService _feedCommentsService;

  @override
  FutureOr<Result<void>> execute(CreateFeedCommentRequest request) async {
    return await _feedCommentsService.createFeedComment(request);
  }
}
