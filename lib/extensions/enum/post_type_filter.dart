import 'package:grimity/api/api.dart';

/// [PostTypeFilter]에 대한 유틸리티 확장.
extension PostTypeFilterExtension on PostTypeFilter {
  /// 게시글 유형 필터의 표시 이름을 반환합니다.
  String get displayName {
    return switch (this) {
      .all => '전체',
      .notice => '공지',
      .normal => '일반',
      .question => '질문',
      .feedback => '피드백',
    };
  }
}
