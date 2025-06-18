import 'package:grimity/app/enum/sort_type.enum.dart';
import 'package:grimity/domain/entity/feeds.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/dto/users_request_params.dart';
import 'package:grimity/domain/usecase/users_usecase.dart';
import 'package:grimity/presentation/profile/provider/selected_album_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_feeds_data_provider.g.dart';

@riverpod
class ProfileFeedsData extends _$ProfileFeedsData {
  @override
  FutureOr<Feeds> build(String userId) async {
    if (userId.isEmpty) {
      return Feeds(feeds: [], nextCursor: '');
    }

    final selectedAlbumId = ref.watch(selectedAlbumProvider);

    final GetUserFeedsRequestParams param = GetUserFeedsRequestParams(
      id: userId,
      size: 10,
      sort: SortType.latest,
      albumId: selectedAlbumId,
    );

    final result = await getUserFeedsUseCase.execute(param);
    return result.fold(onSuccess: (feeds) => feeds, onFailure: (e) => Feeds(feeds: [], nextCursor: ''));
  }

  Future<void> loadMore(String userId) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.nextCursor == null || currentState.nextCursor!.isEmpty || userId.isEmpty) {
      return;
    }

    final selectedAlbumId = ref.read(selectedAlbumProvider);

    final param = GetUserFeedsRequestParams(
      id: userId,
      size: 10,
      sort: SortType.latest,
      cursor: currentState.nextCursor,
      albumId: selectedAlbumId,
    );
    final result = await getUserFeedsUseCase.execute(param);

    result.fold(
      onSuccess: (newFeeds) {
        final updatedFeeds = Feeds(feeds: [...currentState.feeds, ...newFeeds.feeds], nextCursor: newFeeds.nextCursor);
        state = AsyncValue.data(updatedFeeds);
      },
      onFailure: (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }
}

class PostsState {
  final List<Post> posts;
  final bool hasMore;
  final bool isLoading;
  final int currentPage;

  const PostsState({required this.posts, required this.hasMore, required this.isLoading, required this.currentPage});

  PostsState copyWith({List<Post>? posts, bool? hasMore, bool? isLoading, int? currentPage}) {
    return PostsState(
      posts: posts ?? this.posts,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
