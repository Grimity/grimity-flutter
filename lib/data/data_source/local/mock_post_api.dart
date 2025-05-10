import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/data/data_source/remote/post_api.dart';
import 'package:grimity/data/model/post/post_detail_response.dart';
import 'package:grimity/data/model/user/user_response.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

@dev
@Injectable(as: PostAPI)
class MockPostAPI extends Mock implements PostAPI {
  @override
  Future<PostDetailResponse> getPostDetail(String id) async {
    return PostDetailResponse(
      id: id,
      title: 'title',
      content: 'content',
      thumbnail: 'thumbnail',
      createdAt: DateTime.now(),
      type: PostType.normal.name,
      viewCount: 0,
      commentCount: 0,
      author: UserResponse(id: 'id', name: 'name', image: 'image', url: 'url'),
      likeCount: 0,
      isLike: false,
      isSave: false,
    );
  }
}
