import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/tag.dart';
import 'package:grimity/data/service/tag_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPopularTagsUseCase extends NoParamUseCase<Result<List<Tag>>> {
  GetPopularTagsUseCase(this._tagService);

  final TagService _tagService;

  @override
  FutureOr<Result<List<Tag>>> execute() async {
    return await _tagService.getPopularTags();
  }
}
