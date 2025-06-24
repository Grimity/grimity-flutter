import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/entity/users.dart';
import 'package:grimity/domain/usecase/me/get_my_followings_usecase.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:grimity/domain/usecase/users_usecase.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_following_data_provider.g.dart';

// 내 팔로잉 데이터
@riverpod
class FollowingData extends _$FollowingData {
  @override
  FutureOr<Users> build() async {
    final GetMyFollowingsRequestParam param = GetMyFollowingsRequestParam(size: 10);

    final result = await getMyFollowingsUseCase.execute(param);

    return result.fold(onSuccess: (users) => users, onFailure: (e) => Users(users: [], nextCursor: ''));
  }

  Future<void> loadMore() async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.nextCursor == null || currentState.nextCursor!.isEmpty) {
      return;
    }

    final param = GetMyFollowingsRequestParam(size: 10, cursor: currentState.nextCursor);
    final result = await getMyFollowingsUseCase.execute(param);

    result.fold(
      onSuccess: (newUsers) {
        final updatedUsers = Users(users: [...currentState.users, ...newUsers.users], nextCursor: newUsers.nextCursor);
        state = AsyncValue.data(updatedUsers);
      },
      onFailure: (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }

  // 언팔로우
  Future<void> unfollow(String userId) async {
    final currentState = state.valueOrNull;
    if (currentState == null) {
      return;
    }

    final result = await unfollowUserByIdUseCase.execute(userId);

    result.fold(
      onSuccess: (_) {
        // 토탈 팔로우 갱신
        ref.read(userAuthProvider.notifier).getUser();

        final updatedUsers = Users(
          users: currentState.users.where((user) => user.id != userId).toList(),
          nextCursor: currentState.nextCursor,
        );

        state = AsyncValue.data(updatedUsers);
        ToastService.show('언팔로우가 완료되었어요.');
      },
      onFailure: (e) {
        ToastService.showError('언팔로우가 실패했어요.');
      },
    );
  }
}
