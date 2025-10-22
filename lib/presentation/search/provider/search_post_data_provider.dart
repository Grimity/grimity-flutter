import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/enum/search_type.enum.dart';
import 'package:grimity/domain/entity/posts.dart';
import 'package:grimity/domain/usecase/post/search_posts_usecase.dart';
import 'package:grimity/domain/usecase/post_usecases.dart';
import 'package:grimity/presentation/common/mixin/pagination_mixin.dart';
import 'package:grimity/presentation/search/provider/search_keyword_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_post_data_provider.g.dart';

@riverpod
class SearchPostData extends _$SearchPostData with PaginationMixin {
  @override
  Future<Posts> build({required String keyword}) async {
    return await _fetch();
  }

  Future<Posts> _fetch() async {
    final param = SearchPostsRequestParam(
      page: currentPage,
      size: size,
      keyword: keyword,
      searchBy: SearchType.combined,
    );

    final result = await searchPostsUseCase.execute(param);

    return result.fold(onSuccess: (posts) => posts, onFailure: (e) => Posts(posts: [], totalCount: 0));
  }

  Future<void> goToPage(int page) async {
    setPagination(page: page);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch());
  }
}

mixin class SearchPostMixin {
  AsyncValue<Posts> searchPostState(WidgetRef ref) {
    final keyword = ref.watch(searchKeywordProvider);

    return ref.watch(searchPostDataProvider(keyword: keyword));
  }

  SearchPostData searchPostNotifier(WidgetRef ref) {
    final keyword = ref.watch(searchKeywordProvider);

    return ref.read(searchPostDataProvider(keyword: keyword).notifier);
  }

  void invalidateSearchPost(WidgetRef ref) {
    final keyword = ref.watch(searchKeywordProvider);

    ref.invalidate(searchPostDataProvider(keyword: keyword));
  }
}
