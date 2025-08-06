import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/tag.dart';

part 'popular_tag_response.freezed.dart';

part 'popular_tag_response.g.dart';

@Freezed(copyWith: false)
abstract class PopularTagResponse with _$PopularTagResponse {
  const PopularTagResponse._();

  const factory PopularTagResponse({required String tagName, required String thumbnail}) = _PopularTagResponse;

  factory PopularTagResponse.fromJson(Map<String, dynamic> json) => _$PopularTagResponseFromJson(json);
}

extension PopularTagResponseX on PopularTagResponse {
  Tag toEntity() {
    return Tag(tagName: tagName, thumbnail: thumbnail);
  }
}

extension PopularTagResponseListX on List<PopularTagResponse> {
  List<Tag> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
