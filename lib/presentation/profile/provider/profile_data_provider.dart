import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/usecase/users_usecase.dart';
import 'package:grimity/presentation/common/mixin/user_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_data_provider.g.dart';

@riverpod
class ProfileData extends _$ProfileData with UserMixin<User?> {
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

    onToggleFollow(
      ref: ref,
      id: currentState.id,
      follow: !isCurrentlyFollowing,
      optimisticBuilder: (prev) {
        final current = prev?.followerCount ?? 0;
        final nextCount = !isCurrentlyFollowing ? current + 1 : (current - 1).clamp(0, 1 << 31);

        return prev?.copyWith(isFollowing: !isCurrentlyFollowing, followerCount: nextCount);
      },
    );
  }
}
