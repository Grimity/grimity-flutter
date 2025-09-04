import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/provider/home_searching_provider.dart';

import '../../../domain/entity/feed.dart';
import '../../../domain/entity/post.dart';
import '../../../domain/entity/user.dart';

class DrawingHooks {

  // ---- Tabs ----
  static int useSelectedTab(WidgetRef ref) {
    return ref.watch(selectedTabProvider);
  }

  static void useSelectTab(WidgetRef ref, int index) {
    ref.read(selectedTabProvider.notifier).state = index;
  }

  // ---- Categories ----
  static List<String> useCategories(WidgetRef ref) {
    final async = ref.watch(tagNamesProvider);
    return async.maybeWhen(
      data: (v) => v,
      orElse: () => const [],
    );
  }

  static String useSelectedCategory(WidgetRef ref) {
    return ref.watch(selectedCategoryProvider);
  }

  static void useSelectCategory(WidgetRef ref, String category) {
    final current = ref.read(selectedCategoryProvider);
    ref.read(selectedCategoryProvider.notifier).state =
        current == category ? '' : category;
  }

  // ---- Search ----
  static void useSetSearchQuery(WidgetRef ref, String query) {
    ref.read(searchQueryProvider.notifier).state = query;
  }

  static String useSearchQuery(WidgetRef ref) {
    return ref.watch(searchQueryProvider);
  }

  // 피드 검색 결과 (/feeds/search) → List<Feed>
  static List<Feed> useSearchedFeeds(WidgetRef ref) {
    final async = ref.watch(searchedFeedsProvider);
    return async.maybeWhen(
      data: (feeds) => feeds.feeds,
      orElse: () => const [],
    );
  }

  // 유저 검색 결과 (/users/search) → List<User>
  static List<User> useSearchedUsers(WidgetRef ref) {
    final async = ref.watch(searchedUsersProvider);
    return async.maybeWhen(
      data: (users) => users,
      orElse: () => const [],
    );
  }

  // 게시글 검색 결과 (/posts/search) → List<Post>
  static List<Post> useSearchedPosts(WidgetRef ref) {
    final async = ref.watch(searchedPostsProvider);
    return async.maybeWhen(
      data: (posts) => posts,
      orElse: () => const <Post>[],
    );
  }

  // 세 가지를 한 번에 쓰고 싶을 때 (옵션)
  // 사용처에서 null 체크로 로딩/에러 구분 가능
  static SearchAllBundle? useSearchAll(WidgetRef ref) {
    final async = ref.watch(searchAllProvider);
    return async.maybeWhen(data: (bundle) => bundle, orElse: () => null);
  }

}
