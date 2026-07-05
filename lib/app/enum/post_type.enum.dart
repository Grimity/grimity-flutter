import 'package:gds/gds.dart';
import 'package:json_annotation/json_annotation.dart';

enum PostType {
  @JsonValue('NORMAL')
  normal('일반', 'NORMAL'),

  @JsonValue('QUESTION')
  question('질문', 'QUESTION'),

  @JsonValue('FEEDBACK')
  feedback('피드백', 'FEEDBACK'),

  @JsonValue('NOTICE')
  notice('공지', 'NOTICE'),

  @JsonValue('ALL')
  all('전체', 'ALL');

  final String displayName;
  final String jsonKey;
  const PostType(this.displayName, this.jsonKey);

  /// 사용자가 업로드 가능한 [PostType] 목록
  static const List<PostType> uploadableTypes = [
    PostType.normal,
    PostType.question,
    PostType.feedback,
  ];

  static PostType fromString(String value) {
    return PostType.values.firstWhere((e) => e.toJson() == value, orElse: () => PostType.normal);
  }

  String toJson() => jsonKey;

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
