import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/data/data_source/remote/post_api.dart';
import 'package:grimity/data/model/post/post_detail_response.dart';
import 'package:grimity/data/model/post/posts_response.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/repository/post_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PostRepository)
class PostRepositoryImpl extends PostRepository {
  final PostAPI _postAPI;

  PostRepositoryImpl(this._postAPI);

  @override
  Future<Result<List<Post>>> getPosts(int page, int size, PostType type) async {
    try {
      final PostsResponse response = await _postAPI.getPosts(page, size, type);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<Post>> getPostDetail(String id) async {
    try {
      final PostDetailResponse response = await _postAPI.getPostDetail(id);
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> savePost(String id) async {
    try {
      await _postAPI.savePost(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> removeSavedPost(String id) async {
    try {
      await _postAPI.removeSavedPost(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
