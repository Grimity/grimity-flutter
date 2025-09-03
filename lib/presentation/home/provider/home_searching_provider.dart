import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/data/model/search/drawing_model.dart';
import 'package:grimity/app/base/result.dart';
import 'package:grimity/domain/entity/tag.dart';
import 'package:grimity/domain/usecase/tag/get_popular_tags_usecase.dart';
import 'package:grimity/app/di/di_setup.dart'; // getIt
import 'package:grimity/domain/dto/search_feeds_param.dart';
import 'package:grimity/domain/usecase/feed/search_feeds_usecase.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/usecase/users/search_user_usecase.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/usecase/post'

final selectedTabProvider = StateProvider<int>((ref) => 0);

final tagNamesProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  final uc = getIt<GetPopularTagsUseCase>(); // 또는 전역 getPopularTagsUseCase
  final Result<List<Tag>> res = await uc.execute();

  return res.fold(
    onSuccess: (tags) {
      final seen = <String>{};
      final out = <String>[];
      for (final t in tags) {
        final key = t.tagName.trim().toLowerCase();
        if (key.isEmpty) continue;
        if (seen.add(key)) out.add(t.tagName);
      }
      return out;
    },
    onFailure: (e) => throw e,
  );
});

final selectedCategoryProvider = StateProvider<String>((ref) => '');

final searchQueryProvider = StateProvider<String>((ref) => '');

final allUsersProvider = Provider<List<Map<String, String>>>((ref) {
  return const [
  ];
});

final allFreePostsProvider = Provider<List<Map<String, String>>>((ref) {
  return const [
  ];
});

final filteredUsersProvider = Provider<List<Map<String, String>>>((ref) {
  final allUsers = ref.watch(allUsersProvider);
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return allUsers;

  final q = query.toLowerCase();
  return allUsers
      .where((u) => (u['username'] ?? '').toLowerCase().contains(q))
      .toList();
});

final filteredFreePostsProvider = Provider<List<Map<String, String>>>((ref) {
  final allPosts = ref.watch(allFreePostsProvider);
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return allPosts;

  final q = query.toLowerCase();
  return allPosts
      .where((p) => (p['title'] ?? '').toLowerCase().contains(q))
      .toList();
});

final searchedFeedsProvider = FutureProvider.autoDispose<Feeds>((ref) async {
  final q = ref.watch(searchQueryProvider).trim();
  if (q.isEmpty) return Feeds.empty();

  final uc = getIt<SearchFeedsUseCase>();
  final Result<Feeds> res =
  await uc.execute(SearchFeedsParam(keyword: q, sort: 'accuracy', size: 20));

  return res.fold(onSuccess: (v) => v, onFailure: (_) => Feeds.empty());
});
