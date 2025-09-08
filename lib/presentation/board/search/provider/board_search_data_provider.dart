import 'package:grimity/domain/entity/posts.dart';
import 'package:grimity/domain/usecase/post/search_posts_usecase.dart';
import 'package:grimity/domain/usecase/post_usecases.dart';
import 'package:grimity/presentation/board/common/provider/board_search_query_provider.dart';
import 'package:grimity/presentation/common/mixin/pagination_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'board_search_data_provider.g.dart';

@riverpod
class SearchData extends _$SearchData with PaginationMixin {
  @override
  FutureOr<Posts> build() async {
    return _fetch();
  }

  Future<Posts> _fetch() async {
    final searchQueryState = ref.read(searchQueryProvider);

    final SearchPostsRequestParam param = SearchPostsRequestParam(
      page: currentPage,
      size: size,
      keyword: searchQueryState.keyword,
      searchBy: searchQueryState.searchType,
    );

    final result = await searchPostsUseCase.execute(param);

    return result.fold(onSuccess: (posts) => posts, onFailure: (e) => Posts(posts: [], totalCount: 0));
  }

  Future<void> search() async {
    setPagination(page: 1);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch());
  }

  Future<void> goToPage(int page) async {
    setPagination(page: page);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch());
  }
}
