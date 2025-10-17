import 'package:grimity/domain/entity/users.dart';
import 'package:grimity/domain/usecase/me/get_my_followers_usecase.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:grimity/presentation/common/mixin/user_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_followers_data_provider.g.dart';

// 내 팔로워 데이터
@riverpod
class FollowersData extends _$FollowersData with UserMixin<Users> {
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

  Future<void> deleteFollower(String id) => onDeleteFollower(
    ref: ref,
    id: id,
    optimisticBuilder: (prev) {
      return prev.copyWith(users: prev.users.where((user) => user.id != id).toList());
    },
  );
}
