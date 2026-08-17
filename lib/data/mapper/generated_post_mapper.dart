import 'package:grimity/data/gen/models/id_response.dart' as generated;
import 'package:grimity/data/gen/models/post_detail_response.dart' as generated;
import 'package:grimity/data/gen/models/post_with_author_response.dart' as generated;
import 'package:grimity/data/gen/models/posts_response.dart' as generated;
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/entity/posts.dart';
import 'package:grimity/domain/entity/user.dart';

extension GeneratedIdResponseMapper on generated.IdResponse {
  String toEntity() => id;
}

extension GeneratedPostWithAuthorResponseMapper on generated.PostWithAuthorResponse {
  Post toEntity() => Post(
    id: id,
    title: title,
    content: content,
    thumbnail: thumbnail,
    createdAt: createdAt,
    type: type.json,
    viewCount: viewCount.toInt(),
    commentCount: commentCount.toInt(),
    author: User(id: author.id, name: author.name, image: author.image, url: author.url),
  );
}

extension GeneratedPostWithAuthorResponsesMapper on List<generated.PostWithAuthorResponse> {
  List<Post> toEntity() => map((response) => response.toEntity()).toList();
}

extension GeneratedPostsResponseMapper on generated.PostsResponse {
  Posts toEntity() => Posts(posts: posts.toEntity(), totalCount: totalCount.toInt());
}

extension GeneratedPostDetailResponseMapper on generated.PostDetailResponse {
  Post toEntity() => Post(
    id: id,
    title: title,
    content: content,
    thumbnail: thumbnail,
    createdAt: createdAt,
    type: type.json,
    viewCount: viewCount.toInt(),
    commentCount: commentCount.toInt(),
    author: User(id: author.id, name: author.name, image: author.image, url: author.url),
    likeCount: likeCount.toInt(),
    isLike: isLike,
    isSave: isSave,
  );
}
