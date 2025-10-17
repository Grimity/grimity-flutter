import 'package:grimity/domain/entity/users.dart';
import 'package:grimity/domain/usecase/me/get_my_followings_usecase.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:grimity/presentation/common/mixin/user_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_following_data_provider.g.dart';

// 내 팔로잉 데이터
@riverpod
class FollowingData extends _$FollowingData with UserMixin<Users> {
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

  Future<void> unfollow(String id) => onToggleFollow(
    ref: ref,
    id: id,
    follow: false,
    optimisticBuilder: (prev) {
      return prev.copyWith(users: prev.users.where((user) => user.id != id).toList());
    },
  );
}
