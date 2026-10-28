import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_user.dart';

/// [PostDetailResponse]에 대한 유틸리티 확장.
extension PostDetailResponseExtension on PostDetailResponse {
  /// 현재 로그인한 사용자가 작성한 글인지 여부.
  bool get isMine {
    return author.id == profile.id;
  }
}
