import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/link.dart';

part 'link_response.freezed.dart';
part 'link_response.g.dart';

@Freezed(copyWith: false)
abstract class LinkResponse with _$LinkResponse {
  const factory LinkResponse({required String linkName, required String link}) = _LinkResponse;

  factory LinkResponse.fromJson(Map<String, dynamic> json) => _$LinkResponseFromJson(json);
}

extension LinkResponseX on LinkResponse {
  Link toEntity() {
    return Link(linkName: linkName, link: link);
  }
}
