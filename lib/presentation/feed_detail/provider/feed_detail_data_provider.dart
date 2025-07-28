import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/usecase/feed_usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_detail_data_provider.g.dart';

@riverpod
class FeedDetailData extends _$FeedDetailData {
  @override
  FutureOr<Feed?> build(String feedId) async {
    final result = await getFeedDetailUseCase.execute(feedId);

    return result.fold(onSuccess: (feed) => feed, onFailure: (e) => null);
  }

  /// 피드 삭제
  FutureOr<bool> deleteFeed(String id) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return false;

    final result = await deleteFeedUseCase.execute(id);

    final isSuccess = result.fold(
      onSuccess: (value) {
        ToastService.show('삭제가 완료되었습니다.');
        return true;
      },
      onFailure: (e) {
        ToastService.showError('삭제가 실패되었습니다.');
        return false;
      },
    );
    return isSuccess;
  }

  /// 좋아요 토글
  Future<void> toggleLikeFeed(String feedId, bool like) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final result = like ? await likeFeedUseCase.execute(feedId) : await unlikeFeedUseCase.execute(feedId);

    if (result.isSuccess) {
      final updatedFeed = currentState.copyWith(
        likeCount: like ? currentState.likeCount! + 1 : currentState.likeCount! - 1,
        isLike: like,
      );
      state = AsyncValue.data(updatedFeed);
    }
  }

  /// 저장 토글
  Future<void> toggleSaveFeed(String feedId, bool save) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final result = save ? await saveFeedUseCase.execute(feedId) : await removeSavedFeedUseCase.execute(feedId);

    if (result.isSuccess) {
      final updatedFeed = currentState.copyWith(isSave: save);
      state = AsyncValue.data(updatedFeed);
    }
  }
}
