import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/domain/dto/users_request_params.dart';
import 'package:grimity/domain/entity/users.dart';
import 'package:grimity/domain/usecase/users_usecase.dart';
import 'package:grimity/presentation/search/provider/search_keyword_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_user_data_provider.g.dart';

@riverpod
class SearchUserData extends _$SearchUserData {
  @override
  FutureOr<Users> build({required String keyword}) async {
    final param = SearchUserRequestParams(size: 5, keyword: keyword);
    final result = await searchUserUseCase.execute(param);
    return result.fold(onSuccess: (users) => users, onFailure: (e) => Users(users: [], nextCursor: ''));
  }

  Future<void> loadMore() async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.nextCursor == null || currentState.nextCursor!.isEmpty) {
      return;
    }

    final param = SearchUserRequestParams(size: 5, cursor: currentState.nextCursor, keyword: keyword);
    final result = await searchUserUseCase.execute(param);

    result.fold(
      onSuccess: (newUsers) {
        final updatedUsers = newUsers.copyWith(users: [...currentState.users, ...newUsers.users]);
        state = AsyncValue.data(updatedUsers);
      },
      onFailure: (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }
}

mixin class SearchUserMixin {
  AsyncValue<Users> searchUserState(WidgetRef ref) {
    final keyword = ref.watch(searchKeywordProvider);

    return ref.watch(searchUserDataProvider(keyword: keyword));
  }

  SearchUserData searchUserNotifier(WidgetRef ref) {
    final keyword = ref.watch(searchKeywordProvider);

    return ref.read(searchUserDataProvider(keyword: keyword).notifier);
  }
}
