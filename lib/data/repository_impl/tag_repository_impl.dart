import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/data_source/remote/tag_api.dart';
import 'package:grimity/data/model/tag/popular_tag_response.dart';
import 'package:grimity/domain/entity/tag.dart';
import 'package:grimity/domain/repository/tag_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: TagRepository)
class TagRepositoryImpl extends TagRepository {
  final TagAPI _tagAPI;

  TagRepositoryImpl(this._tagAPI);

  @override
  Future<Result<List<Tag>>> getPopularTags() async {
    try {
      final List<PopularTagResponse> response = await _tagAPI.getPopularTags();
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
