import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/search_provider.dart';


class DrawingHooks {
  static List<String> useCategories(WidgetRef ref) {
    final tags = ref.watch(tagNamesProvider);
    return tags.maybeWhen(
      data: (v) => v,
      orElse: () => const <String>[],
    );
  }

  static String useSelectedCategory(WidgetRef ref) =>
      ref.watch(selectedCategoryProvider);

  static void useSelectCategory(WidgetRef ref, String category) {
    ref.read(selectedCategoryProvider.notifier).state = category;
    ref.read(searchQueryProvider.notifier).state = category;
    _refreshByTab(ref);
  }

  static int useSelectedTab(WidgetRef ref) => ref.watch(selectedTabProvider);

  static void useSelectTab(WidgetRef ref, int idx) {
    ref.read(selectedTabProvider.notifier).state = idx;
    _refreshByTab(ref);
  }

  static String useSearchQuery(WidgetRef ref) =>
      ref.watch(searchQueryProvider);


  static void useSetSearchQuery(WidgetRef ref, String q) {
    ref.read(searchQueryProvider.notifier).state = q;
    _refreshByTab(ref);
  }


  static bool useIsQueryValid(WidgetRef ref) {
    final q = ref.watch(searchQueryProvider).trim();
    return q.length >= 2 && q.length <= 20;
  }

  static SearchSort useSearchSort(WidgetRef ref) =>
      ref.watch(searchSortProvider);

  static void useSetSearchSort(WidgetRef ref, SearchSort s) {
    ref.read(searchSortProvider.notifier).state = s;
    _refreshByTab(ref);
  }


  static void _refreshByTab(WidgetRef ref) {
    final tab = ref.read(selectedTabProvider);
    switch (tab) {
      case 0:
        ref.invalidate(searchedFeedsProvider);
        break;
      case 1:
        ref.invalidate(searchedUsersProvider);
        break;
      case 2:
        ref.invalidate(searchedPostsProvider);
        break;
      default:
        break;
    }
  }
}
