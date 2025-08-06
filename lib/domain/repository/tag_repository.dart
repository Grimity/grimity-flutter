import 'package:grimity/app/base/result.dart';
import 'package:grimity/domain/entity/tag.dart';

abstract class TagRepository {
  Future<Result<List<Tag>>> getPopularTags();
}
