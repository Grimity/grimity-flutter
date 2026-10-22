import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_user.dart';

/// [FeedDetailResponse]에 대한 유틸리티 확장.
extension FeedDetailResponseExtension on FeedDetailResponse {
  /// 현재 로그인한 사용자가 작성한 피드인지 여부.
  bool get isMe {
    return author.id == profile.id;
  }
}
