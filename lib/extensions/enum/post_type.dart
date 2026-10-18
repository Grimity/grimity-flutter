import 'package:grimity/api/api.dart';

/// [PostType]에 대한 유틸리티 확장.
extension PostTypeExtension on PostType {
  /// 게시글 유형의 표시 이름을 반환합니다.
  String get displayName {
    return switch (this) {
      .normal => '일반',
      .question => '질문',
      .feedback => '피드백',
      .notice => '공지',
    };
  }
}
