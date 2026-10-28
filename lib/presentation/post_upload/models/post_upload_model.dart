import 'package:grimity/api/api.dart';

/// 게시글 작성과 수정에 필요한 입력 데이터를 관리하는 모델.
class PostUploadModel({
  required final String title,
  required final String content,
  required final PostType type,
  required final bool hasText,
  required final PostUploadModel? parent,
}) {
  factory from(
    PostDetailResponse? data, {
    required String content,
    required bool hasText,
  }) {
    final model = PostUploadModel(
      title: data?.title ?? '',
      content: content,
      type: data?.type ?? .normal,
      hasText: hasText,
      parent: null,
    );

    return model.copyWith(parent: model);
  }

  /// 초기 입력값과 비교하여 변경된 내용이 있는지 여부.
  bool get hasChanges => parent != null && different(parent!);

  /// 필수 입력값을 충족하고 변경된 내용이 있어 제출할 수 있는지 여부.
  bool get canSubmit => title.trim().isNotEmpty && hasText && hasChanges;

  /// 다른 모델과 입력 데이터가 다른지 여부를 반환합니다.
  bool different(PostUploadModel other) {
    return title != other.title || content != other.content || type != other.type;
  }

  /// 지정한 값을 반영한 새 모델을 반환합니다.
  PostUploadModel copyWith({
    String? title,
    String? content,
    PostType? type,
    bool? hasText,
    PostUploadModel? parent,
  }) {
    return .new(
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      hasText: hasText ?? this.hasText,
      parent: parent ?? this.parent,
    );
  }
}
