import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/service/post_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class SavePostUseCase extends UseCase<String, Result<void>> {
  SavePostUseCase(this._postService);

  final PostService _postService;

  @override
  FutureOr<Result<void>> execute(String id) async {
    return await _postService.savePost(id);
  }
}
