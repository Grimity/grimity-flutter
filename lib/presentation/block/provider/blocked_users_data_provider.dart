import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:grimity/presentation/common/mixin/user_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'blocked_users_data_provider.g.dart';

@riverpod
class BlockedUsersData extends _$BlockedUsersData with UserMixin<List<User>> {
  @override
  FutureOr<List<User>> build() async {
    final result = await getBlockedUsersUseCase.execute();
    return result.fold(
      onSuccess: (users) => users,
      onFailure: (e) => throw e,
    );
  }

  Future<void> unblockUser(String id) => onUnblockUser(
    id: id,
    optimisticBuilder: (prev) {
      return prev.where((user) => user.id != id).toList();
    },
  );
}
