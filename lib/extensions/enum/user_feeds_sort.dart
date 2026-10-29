import 'package:grimity/api/api.dart';

/// [UserFeedsSort]에 대한 유틸리티 확장.
extension UserFeedsSortExtension on UserFeedsSort {
  /// 게시글 유형의 표시 이름을 반환합니다.
  String get displayName {
    return switch (this) {
      .latest => '최신순',
      .oldest => '오래된 순',
      .like => '좋아요순',
    };
  }
}
