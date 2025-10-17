import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:grimity/domain/usecase/users_usecase.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/profile/provider/profile_data_provider.dart';

mixin UserMixin<T> {
  AsyncValue<T> get state;

  set state(AsyncValue<T> value);

  /// 현재 로그인 유저 정보를 다시 불러와 최신 상태로 갱신
  Future<void> _refreshCurrentUser(Ref ref) async {
    try {
      /// 1. 유저 정보 최신화
      await ref.read(userAuthProvider.notifier).getUser();

      /// 2. 유저 정보 Url
      final me = ref.read(userAuthProvider);
      final myUrl = me?.url;

      /// 3. 유저 프로필 정보 최신화
      if (myUrl != null) {
        ref.invalidate(profileDataProvider(myUrl));
      }
    } catch (_) {}
  }

  /// User follow/unfollow
  /// - [id]: 팔로우/언팔로우 대상 유저의 고유 ID
  /// - [follow]: true 이면 팔로우 요청, false이면 언팔로우 요청
  /// - [optimisticBuilder]: 현재 상태를 인자로 받아 낙관적(optimistic) UI 상태를 반환하는 함수
  Future<void> onToggleFollow({
    required Ref ref,
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
        _refreshCurrentUser(ref);
      },
      onFailure: (e) {
        state = AsyncValue.error(e, StackTrace.current);
        state = AsyncValue.data(prev);
        ToastService.show('${follow ? '팔로우' : '언팔로우'}가 실패했어요.');
      },
    );
  }

  /// User delete follower
  /// - [id]: 삭제할 팔로워 대상 유저의 고유 ID
  /// - [optimisticBuilder]: 현재 상태를 인자로 받아 낙관적(optimistic) UI 상태를 반환하는 함수
  Future<void> onDeleteFollower({
    required Ref ref,
    required String id,
    required T Function(T prev) optimisticBuilder,
  }) async {
    final prev = state.valueOrNull;
    if (prev == null) return;

    final optimistic = optimisticBuilder(prev);
    state = AsyncValue.data(optimistic);

    final result = await deleteFollowerByIdUseCase.execute(id);

    result.fold(
      onSuccess: (_) {
        ToastService.show('삭제가 완료되었어요.');
        _refreshCurrentUser(ref);
      },
      onFailure: (e) {
        state = AsyncValue.error(e, StackTrace.current);
        state = AsyncValue.data(prev);
        ToastService.show('삭제가 실패했어요.');
      },
    );
  }
}
