import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/entity/users.dart';
import 'package:grimity/domain/usecase/me/get_my_followers_usecase.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_followers_data_provider.g.dart';

// 내 팔로워 데이터
@riverpod
class FollowersData extends _$FollowersData {
  @override
  FutureOr<Users> build() async {
    final GetMyFollowersRequestParam param = GetMyFollowersRequestParam(size: 10);

    final result = await getMyFollowersUseCase.execute(param);

    return result.fold(onSuccess: (users) => users, onFailure: (e) => Users(users: [], nextCursor: ''));
  }

  Future<void> loadMore() async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.nextCursor == null || currentState.nextCursor!.isEmpty) {
      return;
    }

    final param = GetMyFollowersRequestParam(size: 10, cursor: currentState.nextCursor);
    final result = await getMyFollowersUseCase.execute(param);

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

  // 팔로워 삭제
  Future<void> deleteFollower(String userId) async {
    final currentState = state.valueOrNull;
    if (currentState == null) {
      return;
    }

    final result = await deleteFollowerByIdUseCase.execute(userId);

    result.fold(
      onSuccess: (_) {
        // 토탈 팔로워 갱신
        ref.read(userAuthProvider.notifier).getUser();

        final updatedUsers = Users(
          users: currentState.users.where((user) => user.id != userId).toList(),
          nextCursor: currentState.nextCursor,
        );

        state = AsyncValue.data(updatedUsers);
        ToastService.show('삭제가 완료되었어요.');
      },
      onFailure: (e) {
        ToastService.showError('삭제가 실패했어요.');
      },
    );
  }
}
