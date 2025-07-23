import 'package:freezed_annotation/freezed_annotation.dart';

part 'feeds_request_param.freezed.dart';

part 'feeds_request_param.g.dart';

@freezed
abstract class GetFeedRankingsRequest with _$GetFeedRankingsRequest {
  const factory GetFeedRankingsRequest({String? month, String? startDate, String? endDate}) = _GetFeedRankingsRequest;

  factory GetFeedRankingsRequest.fromJson(Map<String, dynamic> json) => _$GetFeedRankingsRequestFromJson(json);
}

@freezed
abstract class CreateFeedRequest with _$CreateFeedRequest {
  const factory CreateFeedRequest({
    required String title,
    required List<String> cards,
    required String content,
    required List<String> tags,
    required String thumbnail,
    String? albumId,
  }) = _CreateFeedRequest;

  factory CreateFeedRequest.fromJson(Map<String, dynamic> json) => _$CreateFeedRequestFromJson(json);
}
