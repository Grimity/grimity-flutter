import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/gen/rest_client.dart';
import 'package:grimity/data/mapper/generated_common_mapper.dart';
import 'package:grimity/domain/entity/tag.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TagService {
  final RestClient _client;

  TagService(this._client);

  Future<Result<List<Tag>>> getPopularTags() async {
    try {
      final response = await _client.tags.tagFindPopularTags();
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
