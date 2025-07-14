import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/posts.dart';
import 'package:grimity/domain/repository/me_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSavePostsUseCase extends UseCase<GetSavePostsRequestParam, Result<Posts>> {
  GetSavePostsUseCase(this._meRepository);

  final MeRepository _meRepository;

  @override
  Future<Result<Posts>> execute(GetSavePostsRequestParam request) async {
    final result = await _meRepository.getSavePosts(request.page, request.size);

    // 저장 값을 내려 주지 않아 강제 세팅
    return result.fold(
      onSuccess: (posts) => Result.success(posts.overrideSaveStateToTrue()),
      onFailure: (e) => Result.failure(e),
    );
  }
}

class GetSavePostsRequestParam {
  final int page;
  final int size;

  GetSavePostsRequestParam({required this.page, required this.size});
}
