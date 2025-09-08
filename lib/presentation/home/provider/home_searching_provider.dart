import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/app/enum/sort_type.enum.dart';

import 'package:grimity/domain/entity/tag.dart';
import 'package:grimity/domain/usecase/tag/get_popular_tags_usecase.dart';

import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/usecase/feed/search_feeds_usecase.dart';
import 'package:grimity/domain/dto/search_feeds_param.dart';

import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/usecase/post/search_posts_usecase.dart';
import 'package:grimity/domain/dto/search_posts_param.dart';
import 'package:grimity/app/enum/search_post_type.enum.dart';

import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/entity/users.dart';
import 'package:grimity/domain/usecase/users/search_user_usecase.dart';
import 'package:grimity/domain/dto/users_request_params.dart';

/// 선택된 상단 탭 (0: 그림/피드, 1: 유저, 2: 게시글)
final selectedTabProvider = StateProvider<int>((ref) => 0);

/// 선택된 카테고리(태그)
final selectedCategoryProvider = StateProvider<String>((ref) => '');

/// 검색어
final searchQueryProvider = StateProvider<String>((ref) => '');

/// 인기 태그(tagName만) 가져오기
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

/// 피드 검색 (/feeds/search)
final searchedFeedsProvider = FutureProvider.autoDispose<Feeds>((ref) async {
  final q      = ref.watch(searchQueryProvider).trim();
  final uiSort = ref.watch(searchSortProvider);
  if (q.length < 2 || q.length > 20) return Feeds.empty();

  SortType mapFeedSort(SearchSort s) => switch (s) {
    SearchSort.recent   => SortType.latest,
    SearchSort.popular  => SortType.like,
    SearchSort.accuracy => SortType.latest,
  };

  final uc  = getIt<SearchFeedsUseCase>();
  final res = await uc.execute(
    SearchFeedsParam(
      keyword: q,
      sort: mapFeedSort(uiSort),
      size: 20,
    ),
  );

  return res.fold(onSuccess: (v) => v, onFailure: (_) => Feeds.empty());
});

/// 게시글 검색 (/posts/search)
final searchedPostsProvider = FutureProvider.autoDispose<List<Post>>((ref) async {
  final q = ref.watch(searchQueryProvider).trim();
  if (q.isEmpty) return <Post>[];

  final uc = getIt<SearchPostsUseCase>();
  final res = await uc.execute(SearchPostsParam(
    keyword: q,
    page: 1,
    size: 20,
    searchBy: SearchBy.combined,
  ));

  return res.fold(onSuccess: (v) => v, onFailure: (_) => <Post>[]);
});

/// 유저 검색 (/users/search)
/// Users 엔티티를 받아서 List<User>로 풀어서 반환
final searchedUsersProvider = FutureProvider.autoDispose<List<User>>((ref) async {
  final q = ref.watch(searchQueryProvider).trim();
  if (q.isEmpty) return const <User>[];

  final uc = getIt<SearchUserUseCase>();
  final Result<Users> res = await uc.execute(
    SearchUserRequestParams(keyword: q, size: 20, cursor: null),
  );

  return res.fold(
    onSuccess: (v) => v.users, // Users 안의 List<User>
    onFailure: (_) => <User>[],
  );
});

/// 세 가지를 한 번에 가져오고 싶을 때 사용할 번들 + Provider
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

  // 병렬 요청
  final feedsF = ref.read(searchedFeedsProvider.future);
  final usersF = ref.read(searchedUsersProvider.future);
  final postsF = ref.read(searchedPostsProvider.future);

  final results = await Future.wait([feedsF, usersF, postsF]);

  final feeds = (results[0] as Feeds).feeds;
  final users = (results[1] as List<User>);
  final posts = (results[2] as List<Post>);

  return SearchAllBundle(feeds: feeds, users: users, posts: posts);
});

//정렬기능
enum SearchSort { accuracy, recent, popular }
final searchSortProvider = StateProvider<SearchSort>((ref) => SearchSort.accuracy);