import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/usecase/users_usecase.dart';

mixin UserMixin<T> {
  AsyncValue<T> get state;

  set state(AsyncValue<T> value);

  /// User follow/unfollow
  /// - [id]: 팔로우/언팔로우 대상 유저의 고유 ID
  /// - [follow]: true 이면 팔로우 요청, false이면 언팔로우 요청
  /// - [optimisticBuilder]: 현재 상태를 인자로 받아 낙관적(optimistic) UI 상태를 반환하는 함수
  Future<void> onToggleFollow({
    required String id,
    required bool follow,
    required T Function(T prev) optimisticBuilder,
  }) async {
    final prev = state.valueOrNull;
    if (prev == null) return;

    final optimistic = optimisticBuilder(prev);
    state = AsyncValue.data(optimistic);

    final result = follow ? await followUserByIdUseCase.execute(id) : await unfollowUserByIdUseCase.execute(id);

    result.fold(
      onSuccess: (_) {
        ToastService.show('${follow ? '팔로우' : '언팔로우'}가 완료되었어요.');
      },
      onFailure: (e) {
        state = AsyncValue.error(e, StackTrace.current);
        state = AsyncValue.data(prev);
        ToastService.show('${follow ? '팔로우' : '언팔로우'}가 실패했어요.');
      },
    );
  }
}
