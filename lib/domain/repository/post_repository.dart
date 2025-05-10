import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/domain/entity/post.dart';

abstract class PostRepository {
  Future<Result<List<Post>>> getPosts(int page, int size, PostType type);
  Future<Result<Post>> getPostDetail(String id);
}
