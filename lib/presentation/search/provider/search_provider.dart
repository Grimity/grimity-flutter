import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/app/enum/sort_type.enum.dart';

import 'package:grimity/domain/entity/tag.dart';
import 'package:grimity/domain/usecase/tag/get_popular_tags_usecase.dart';

import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/usecase/search/search_feeds_usecase.dart';
import 'package:grimity/domain/dto/search_feeds_params.dart';

import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/usecase/post/search_posts_usecase.dart';
import 'package:grimity/domain/dto/search_posts_params.dart';
import 'package:grimity/app/enum/search_type.enum.dart';

import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/entity/users.dart';
import 'package:grimity/domain/usecase/users/search_user_usecase.dart';
import 'package:grimity/domain/dto/users_request_params.dart';

import 'debounced_query_provider.dart';

final selectedTabProvider = StateProvider<int>((ref) => 0);

final selectedCategoryProvider = StateProvider<String>((ref) => '');

final searchQueryProvider = StateProvider<String>((ref) => '');

final tagNamesProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  final uc = getIt<GetPopularTagsUseCase>();
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


final searchedFeedsProvider = FutureProvider.autoDispose<Feeds>((ref) async {
  final q = await ref.watch(debouncedQueryProvider.future);

  final uiSort = ref.watch(searchSortProvider);
  if (q.length < 2 || q.length > 20) return Feeds.empty();

  SortType mapFeedSort(SearchSort s) => switch (s) {
    SearchSort.recent   => SortType.latest,
    SearchSort.popular  => SortType.like,
    SearchSort.accuracy => SortType.latest,
  };

  final uc  = getIt<SearchFeedsUseCase>();
  final res = await uc.execute(
    SearchFeedsParams(
      keyword: q,
      sort: mapFeedSort(uiSort),
      size: 20,
    ),
  );

  return res.fold(onSuccess: (v) => v, onFailure: (_) => Feeds.empty());
});


final searchedPostsProvider = FutureProvider.autoDispose<List<Post>>((ref) async {
  final q = await ref.watch(debouncedQueryProvider.future);
  if (q.length < 2 || q.length > 20) return <Post>[];

  final uc = getIt<SearchPostsUseCase>();
  final res = await uc.execute(
    SearchPostsParam(
      keyword: q,
      page: 1,
      size: 20,
      searchType: SearchType.combined,
    ) as SearchPostsRequestParam,
  );

  return res.fold(
    onSuccess: (page) => page.posts,
    onFailure: (_) => <Post>[],
  );
});


final searchedUsersProvider = FutureProvider.autoDispose<List<User>>((ref) async {
  final q = await ref.watch(debouncedQueryProvider.future);
  if (q.length < 2 || q.length > 20) return const <User>[];

  final uc = getIt<SearchUserUseCase>();
  final Result<Users> res = await uc.execute(
    SearchUserRequestParams(keyword: q, size: 20, cursor: null),
  );

  return res.fold(onSuccess: (v) => v.users, onFailure: (_) => <User>[]);
});

class SearchAllBundle {
  final List<Feed> feeds;
  final List<User> users;
  final List<Post> posts;
  const SearchAllBundle({
    this.feeds = const [],
    this.users = const [],
    this.posts = const [],
  });
  const SearchAllBundle.empty() : this();
}

final searchAllProvider = FutureProvider.autoDispose<SearchAllBundle>((ref) async {
  final query = ref.watch(searchQueryProvider).trim();
  if (query.isEmpty) return const SearchAllBundle.empty();

  final feedsF = ref.read(searchedFeedsProvider.future);
  final usersF = ref.read(searchedUsersProvider.future);
  final postsF = ref.read(searchedPostsProvider.future);

  final results = await Future.wait([feedsF, usersF, postsF]);

  final feeds = (results[0] as Feeds).feeds;
  final users = (results[1] as List<User>);
  final posts = (results[2] as List<Post>);

  return SearchAllBundle(feeds: feeds, users: users, posts: posts);
});


enum SearchSort { accuracy, recent, popular }
final searchSortProvider = StateProvider<SearchSort>((ref) => SearchSort.accuracy);