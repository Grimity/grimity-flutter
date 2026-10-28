import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';

/// 피드 작성과 수정에 필요한 입력 데이터를 관리하는 모델.
class FeedUploadModel({
  required final List<ImageProvider> images,
  required final ImageProvider? thumbnail,
  required final String title,
  required final String content,
  required final List<String> tags,
  required final AlbumBaseResponse? album,
  required final FeedUploadModel? parent,
}) {
  factory from(FeedDetailResponse? data) {
    final model = FeedUploadModel(
      images: data?.cards.toImages() ?? [],
      thumbnail: data?.thumbnail.toImage(),
      title: data?.title ?? '',
      content: data?.content ?? '',
      tags: data?.tags ?? [],
      album: data?.album,
      parent: null,
    );

    return model.copyWith(parent: model);
  }

  /// 초기 입력값과 비교하여 변경된 내용이 있는지 여부.
  bool get hasChanges => parent != null && different(parent!);

  /// 필수 입력값을 충족하고 변경된 내용이 있어 제출할 수 있는지 여부.
  bool get canSubmit {
    return images.isNotEmpty && title.trim().isNotEmpty && content.trim().isNotEmpty && hasChanges;
  }

  /// 다른 모델과 입력 데이터가 다른지 여부를 반환합니다.
  bool different(FeedUploadModel other) {
    return !listEquals(other.images, images) ||
        other.thumbnail != thumbnail ||
        other.title != title ||
        other.content != content ||
        !listEquals(other.tags, tags) ||
        other.album?.id != album?.id;
  }

  /// 지정한 값을 반영한 새 모델을 반환합니다.
  FeedUploadModel copyWith({
    List<ImageProvider>? images,
    ImageProvider? thumbnail,
    String? title,
    String? content,
    List<String>? tags,
    AlbumBaseResponse? album,
    FeedUploadModel? parent,
  }) {
    return .new(
      images: images ?? this.images,
      thumbnail: thumbnail ?? this.thumbnail,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      album: album ?? this.album,
      parent: parent ?? this.parent,
    );
  }
}
