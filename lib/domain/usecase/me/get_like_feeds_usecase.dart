import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/data/service/me_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetLikeFeedsUseCase extends UseCase<GetLikeFeedsRequestParam, Result<Feeds>> {
  GetLikeFeedsUseCase(this._meService);

  final MeService _meService;

  @override
  Future<Result<Feeds>> execute(GetLikeFeedsRequestParam request) async {
    final result = await _meService.getLikeFeeds(request.size, request.cursor);

    // 좋아요 값을 내려 주지 않아 강제 세팅
    return result.fold(
      onSuccess: (feeds) => Result.success(feeds.overrideLikeStateToTrue()),
      onFailure: (e) => Result.failure(e),
    );
  }
}

class GetLikeFeedsRequestParam {
  final int? size;
  final String? cursor;

  GetLikeFeedsRequestParam({this.size, this.cursor});
}
