import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag.freezed.dart';

part 'tag.g.dart';

@freezed
abstract class Tag with _$Tag {
  const factory Tag({required String tagName, required String thumbnail}) = _Tag;

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  factory Tag.empty() => Tag(tagName: '', thumbnail: '');

  static List<Tag> get emptyList => [Tag.empty(), Tag.empty(), Tag.empty()];
}
