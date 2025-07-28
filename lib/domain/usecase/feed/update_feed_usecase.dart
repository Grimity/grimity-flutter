import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/feeds_request_param.dart';
import 'package:grimity/domain/repository/feed_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateFeedUseCase extends UseCase<UpdateFeedUseCaseParam, Result<void>> {
  UpdateFeedUseCase(this._feedRepository);

  final FeedRepository _feedRepository;

  @override
  FutureOr<Result<void>> execute(UpdateFeedUseCaseParam param) async {
    return await _feedRepository.updateFeed(param.id, param.request);
  }
}
