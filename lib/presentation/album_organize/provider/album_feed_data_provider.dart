import 'package:grimity/app/enum/sort_type.enum.dart';
import 'package:grimity/domain/dto/users_request_params.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/usecase/users_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_feed_data_provider.g.dart';

@riverpod
class AlbumFeedData extends _$AlbumFeedData {
  @override
  FutureOr<Feeds> build(String userId, String? albumId) async {
    final GetUserFeedsRequestParams param = GetUserFeedsRequestParams(
      id: userId,
      size: 10,
      sort: SortType.latest,
      albumId: albumId,
    );

    final result = await getUserFeedsUseCase.execute(param);
    return result.fold(onSuccess: (feeds) => feeds, onFailure: (e) => Feeds(feeds: [], nextCursor: ''));
  }

  Future<void> loadMore() async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.nextCursor == null || currentState.nextCursor!.isEmpty || userId.isEmpty) {
      return;
    }

    final param = GetUserFeedsRequestParams(
      id: userId,
      size: 10,
      sort: SortType.latest,
      cursor: currentState.nextCursor,
      albumId: albumId,
    );
    final result = await getUserFeedsUseCase.execute(param);

    result.fold(
      onSuccess: (newFeeds) {
        final updatedFeeds = Feeds(feeds: [...currentState.feeds, ...newFeeds.feeds], nextCursor: newFeeds.nextCursor);
        state = AsyncValue.data(updatedFeeds);
      },
      onFailure: (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }
}
