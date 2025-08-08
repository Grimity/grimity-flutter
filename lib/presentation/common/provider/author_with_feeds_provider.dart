import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/enum/sort_type.enum.dart';
import 'package:grimity/domain/dto/users_request_params.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/usecase/users_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'author_with_feeds_provider.g.dart';

part 'author_with_feeds_provider.freezed.dart';

@riverpod
class AuthorWithFeedsData extends _$AuthorWithFeedsData {
  @override
  FutureOr<List<AuthorWithFeeds>> build() async {
    final userResult = await getPopularUsersUseCase.execute();
    final users =
        userResult.fold(onSuccess: (users) => [...users.users]..shuffle(), onFailure: (e) => []).take(8).toList();

    final authorWithFeeds = await Future.wait(
      users.map((user) async {
        final feedResult = await getUserFeedsUseCase.execute(
          GetUserFeedsRequestParams(id: user.id, size: 3, sort: SortType.latest),
        );
        final feeds = feedResult.fold(onSuccess: (feeds) => feeds.feeds, onFailure: (e) => <Feed>[]);
        return AuthorWithFeeds(user: user, feeds: feeds);
      }),
    );

    return authorWithFeeds;
  }
}

@freezed
abstract class AuthorWithFeeds with _$AuthorWithFeeds {
  const factory AuthorWithFeeds({required User user, required List<Feed> feeds}) = _AuthorWithFeeds;

  factory AuthorWithFeeds.empty() => AuthorWithFeeds(user: User.empty(), feeds: Feed.emptyList);

  static List<AuthorWithFeeds> get emptyList => [
    AuthorWithFeeds.empty(),
    AuthorWithFeeds.empty(),
    AuthorWithFeeds.empty(),
  ];
}
