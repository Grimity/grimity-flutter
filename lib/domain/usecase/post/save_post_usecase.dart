import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/repository/post_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SavePostUseCase extends UseCase<String, Result<void>> {
  SavePostUseCase(this._postRepository);

  final PostRepository _postRepository;

  @override
  FutureOr<Result<void>> execute(String id) async {
    return await _postRepository.savePost(id);
  }
}
