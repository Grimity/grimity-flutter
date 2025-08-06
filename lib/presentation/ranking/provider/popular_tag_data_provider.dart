import 'package:grimity/domain/entity/tag.dart';
import 'package:grimity/domain/usecase/tag_usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'popular_tag_data_provider.g.dart';

@riverpod
class PopularTagData extends _$PopularTagData {
  @override
  FutureOr<List<Tag>> build() async {
    final result = await getPopularTagsUseCase.execute();

    return result.fold(onSuccess: (tags) => tags, onFailure: (e) => []);
  }
}
