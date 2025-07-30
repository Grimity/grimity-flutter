import 'package:grimity/app/enum/sort_type.enum.dart';
import 'package:grimity/domain/dto/users_request_params.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/usecase/users_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_author_feeds_data_provider.g.dart';

@riverpod
class FeedAuthorFeedsData extends _$FeedAuthorFeedsData {
  @override
  FutureOr<Feeds> build(String userId) async {
    if (userId.isEmpty) return Feeds(feeds: [], nextCursor: '');

    final param = GetUserFeedsRequestParams(id: userId, size: 6, sort: SortType.latest);

    final result = await getUserFeedsUseCase.execute(param);
    return result.fold(onSuccess: (feeds) => feeds, onFailure: (e) => Feeds(feeds: [], nextCursor: ''));
  }
}
