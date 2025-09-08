import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/domain/entity/post.dart';
import '../../app/enum/search_post_type.enum.dart';

abstract class PostRepository {
  Future<Result<List<Post>>> getPosts(int page, int size, PostType type);
  Future<Result<Post>> getPostDetail(String id);
  Future<Result<void>> savePost(String id);
  Future<Result<void>> removeSavedPost(String id);
  Future<Result<List<Post>>> searchPosts({
    required int page,
    required int size,
    required String keyword,
    required SearchBy searchBy,
  });
}
