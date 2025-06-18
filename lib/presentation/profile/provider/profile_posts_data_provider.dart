import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/dto/users_request_params.dart';
import 'package:grimity/domain/usecase/users_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_posts_data_provider.g.dart';

@riverpod
class ProfilePostsData extends _$ProfilePostsData {
  @override
  FutureOr<List<Post>> build(String userId) async {
    if (userId.isEmpty) {
      return [];
    }

    final GetUserPostsRequestParams param = GetUserPostsRequestParams(id: userId, page: 1, size: 10);

    final result = await getUserPostsUseCase.execute(param);
    return result.fold(onSuccess: (posts) => posts, onFailure: (e) => []);
  }

  Future<void> loadMore(String userId) async {
    final currentState = state.valueOrNull;
    if (currentState == null || userId.isEmpty || currentState.length % 10 != 0) {
      return;
    }

    final param = GetUserPostsRequestParams(id: userId, page: currentState.length ~/ 10 + 1, size: 10);
    final result = await getUserPostsUseCase.execute(param);

    result.fold(
      onSuccess: (newPosts) {
        final updatedPosts = [...currentState, ...newPosts];
        state = AsyncValue.data(updatedPosts);
      },
      onFailure: (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }
}
