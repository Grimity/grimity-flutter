import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/post_comments_request_params.dart';
import 'package:grimity/data/service/post_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdatePostUseCase extends UseCase<UpdatePostWithIdRequestParam, Result<void>> {
  UpdatePostUseCase(this._postService);

  final PostService _postService;

  @override
  FutureOr<Result<void>> execute(UpdatePostWithIdRequestParam request) async {
    return await _postService.updatePost(request.id, request.param);
  }
}
