import 'package:grimity/api/api.dart';
import 'package:pervice_openapi/pervice_openapi.dart';

/// [bool]에 대한 유틸리티 확장.
extension BoolExtension on bool {
  /// 현재 값에 따라 피드에 좋아요를 등록하거나 해제하는 서비스를 반환합니다.
  OpenApiService feedLikeServiceOf(String id) {
    return this ? PutFeedsByIdLike(id: id) : DeleteFeedsByIdLike(id: id);
  }

  /// 현재 값에 따라 피드 댓글에 좋아요를 등록하거나 해제하는 서비스를 반환합니다.
  OpenApiService feedCommentLikeServiceOf(String id) {
    return this ? PutFeedCommentsByIdLike(id: id) : DeleteFeedCommentsByIdLike(id: id);
  }
}
