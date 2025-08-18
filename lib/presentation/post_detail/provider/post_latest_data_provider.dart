import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/usecase/post/get_posts_usecase.dart';
import 'package:grimity/domain/usecase/post_usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_latest_data_provider.g.dart';

@riverpod
class PostLatestData extends _$PostLatestData {
  @override
  FutureOr<List<Post>> build() async {
    final GetPostsRequestParam param = GetPostsRequestParam(page: 1, size: 5, type: PostType.all);

    final result = await getPostsUseCase.execute(param);

    return result.fold(onSuccess: (posts) => posts.posts, onFailure: (e) => []);
  }
}
