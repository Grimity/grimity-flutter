import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/usecase/feed_usecases.dart';
import 'package:grimity/presentation/common/mixin/feed_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_detail_data_provider.g.dart';

@riverpod
class FeedDetailData extends _$FeedDetailData with FeedMixin<Feed?> {
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

  Future<void> toggleLike({required String feedId, required bool like}) => onToggleLike(
    feedId: feedId,
    like: like,
    optimisticBuilder: (prev) {
      return prev?.copyWith(likeCount: like ? prev.likeCount! + 1 : prev.likeCount! - 1, isLike: like);
    },
  );

  Future<void> toggleSave({required String feedId, required bool save}) => onToggleSave(
    feedId: feedId,
    save: save,
    optimisticBuilder: (prev) {
      return prev?.copyWith(isSave: save);
    },
  );
}
