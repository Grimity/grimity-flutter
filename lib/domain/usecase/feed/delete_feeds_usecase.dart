import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/feeds_request_param.dart';
import 'package:grimity/domain/repository/feed_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteFeedsUseCase extends UseCase<DeleteFeedsRequest, Result<void>> {
  DeleteFeedsUseCase(this._feedRepository);

  final FeedRepository _feedRepository;

  @override
  FutureOr<Result<void>> execute(DeleteFeedsRequest request) async {
    return await _feedRepository.deleteFeeds(request);
  }
}
