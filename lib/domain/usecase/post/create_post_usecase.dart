import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/post_comments_request_params.dart';
import 'package:grimity/domain/repository/post_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreatePostUseCase extends UseCase<CreatePostRequest, Result<String>> {
  CreatePostUseCase(this._postRepository);

  final PostRepository _postRepository;

  @override
  FutureOr<Result<String>> execute(CreatePostRequest request) async {
    return await _postRepository.createPost(request);
  }
}
