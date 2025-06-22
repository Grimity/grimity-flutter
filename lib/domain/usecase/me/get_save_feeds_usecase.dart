import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/repository/me_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSaveFeedsUseCase extends UseCase<GetSaveFeedsRequestParam, Result<Feeds>> {
  GetSaveFeedsUseCase(this._meRepository);

  final MeRepository _meRepository;

  @override
  Future<Result<Feeds>> execute(GetSaveFeedsRequestParam request) async {
    final result = await _meRepository.getSaveFeeds(request.size, request.cursor);

    // 저장 값을 내려 주지 않아 강제 세팅
    return result.fold(
      onSuccess: (feeds) => Result.success(feeds.overrideSaveStateToTrue()),
      onFailure: (e) => Result.failure(e),
    );
  }
}

class GetSaveFeedsRequestParam {
  final int? size;
  final String? cursor;

  GetSaveFeedsRequestParam({this.size, this.cursor});
}
