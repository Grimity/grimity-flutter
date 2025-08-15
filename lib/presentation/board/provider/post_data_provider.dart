import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/domain/entity/posts.dart';
import 'package:grimity/domain/usecase/post/get_posts_usecase.dart';
import 'package:grimity/domain/usecase/post_usecases.dart';
import 'package:grimity/presentation/common/mixin/pagination_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_data_provider.g.dart';

@riverpod
class PostData extends _$PostData with PaginationMixin {
  @override
  FutureOr<Posts> build(PostType type) async {
    return await _fetch(currentPage);
  }

  Future<Posts> _fetch(int page) async {
    final GetPostsRequestParam param = GetPostsRequestParam(page: currentPage, size: size, type: type);

    final result = await getPostsUseCase.execute(param);

    return result.fold(onSuccess: (posts) => posts, onFailure: (e) => Posts(posts: [], totalCount: 0));
  }

  Future<void> goToPage(int page) async {
    setPagination(page: page);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(page));
  }
}
