import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gds/gds.dart';

enum PostType {
  @JsonValue('NORMAL')
  normal('일반'),
  @JsonValue('QUESTION')
  question('질문'),
  @JsonValue('FEEDBACK')
  feedback('피드백'),
  @JsonValue('NOTICE')
  notice('공지'),
  @JsonValue('ALL')
  all('전체');

  final String displayName;

  const PostType(this.displayName);

  static PostType fromString(String value) {
    return PostType.values.firstWhere((e) => e.toJson() == value, orElse: () => PostType.normal);
  }

  String toJson() {
    switch (this) {
      case PostType.normal:
        return 'NORMAL';
      case PostType.question:
        return 'QUESTION';
      case PostType.feedback:
        return 'FEEDBACK';
      case PostType.notice:
        return 'NOTICE';
      case PostType.all:
        return 'ALL';
    }
  }

  GdsChipVariant get chipVariant => switch (this) {
    PostType.normal => GdsChipVariant.assistive,
    PostType.question => GdsChipVariant.assistive,
    PostType.feedback => GdsChipVariant.assistive,
    PostType.notice => GdsChipVariant.primary,
    PostType.all => GdsChipVariant.assistive,
  };

  // Chip 스타일 구분
  // 공지 사항의 경우 Light Chip 사용
  bool get isLightChip => this == notice;
}
