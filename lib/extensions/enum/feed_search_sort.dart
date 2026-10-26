import 'package:grimity/api/api.dart';

/// [FeedSearchSort]에 대한 유틸리티 확장.
extension FeedSearchSortExtension on FeedSearchSort {
  /// 피드 검색 유형의 표시 이름을 반환합니다.
  String get displayName {
    return switch (this) {
      .latest => '최신순',
      .popular => '인기순',
    };
  }
}
