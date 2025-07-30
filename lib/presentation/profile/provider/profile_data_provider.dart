import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/usecase/users_usecase.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_data_provider.g.dart';

@riverpod
class ProfileData extends _$ProfileData {
  @override
  FutureOr<User?> build(String url) async {
    if (url.isEmpty) return null;

    final result = await getUserProfileByUrlUseCase.execute(url);

    return result.fold(onSuccess: (profile) => profile, onFailure: (e) => null);
  }

  Future<void> toggleFollow() async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    // 현재 팔로잉 상태
    final isCurrentlyFollowing = currentState.isFollowing;
    if (isCurrentlyFollowing == null) return;

    if (isCurrentlyFollowing) {
      // 언팔로우
      final result = await unfollowUserByIdUseCase.execute(currentState.id);
      result.fold(
        onSuccess: (_) {
          ref.read(userAuthProvider.notifier).getUser();
          state = AsyncData(currentState.copyWith(isFollowing: false));
          ToastService.show('언팔로우가 완료되었어요.');
        },
        onFailure: (e) {
          ToastService.showError('언팔로우가 실패했어요.');
        },
      );
    } else {
      // 팔로우
      final result = await followUserByIdUseCase.execute(currentState.id);
      result.fold(
        onSuccess: (_) {
          ref.read(userAuthProvider.notifier).getUser();
          state = AsyncData(currentState.copyWith(isFollowing: true));
          ToastService.show('팔로우가 완료되었어요.');
        },
        onFailure: (e) {
          ToastService.showError('팔로우가 실패했어요.');
        },
      );
    }
  }
}
