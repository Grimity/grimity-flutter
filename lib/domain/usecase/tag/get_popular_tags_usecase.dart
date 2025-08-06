import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/tag.dart';
import 'package:grimity/domain/repository/tag_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPopularTagsUseCase extends NoParamUseCase<Result<List<Tag>>> {
  GetPopularTagsUseCase(this._tagRepository);

  final TagRepository _tagRepository;

  @override
  FutureOr<Result<List<Tag>>> execute() async {
    return await _tagRepository.getPopularTags();
  }
}
