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

@freezed
abstract class UpdateFeedUseCaseParam with _$UpdateFeedUseCaseParam {
  const factory UpdateFeedUseCaseParam({required String id, required UpdateFeedRequest request, String? albumId}) =
      _UpdateFeedUseCaseParam;

  factory UpdateFeedUseCaseParam.fromJson(Map<String, dynamic> json) => _$UpdateFeedUseCaseParamFromJson(json);
}

@freezed
abstract class UpdateFeedRequest with _$UpdateFeedRequest {
  const factory UpdateFeedRequest({
    required String title,
    required List<String> cards,
    required String content,
    required List<String> tags,
    required String thumbnail,
    String? albumId,
  }) = _UpdateFeedRequest;

  factory UpdateFeedRequest.fromJson(Map<String, dynamic> json) => _$UpdateFeedRequestFromJson(json);
}
