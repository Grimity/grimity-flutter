import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/enum/sort_type.enum.dart';

part 'getuserfeeds_request_params.freezed.dart';
part 'getuserfeeds_request_params.g.dart';

@freezed
abstract class GetUserFeedsRequestParams with _$GetUserFeedsRequestParams {
  const factory GetUserFeedsRequestParams({
    required String id,
    String? cursor,
    int? size,
    SortType? sort,
    String? albumId,
  }) = _GetUserFeedsRequestParams;

  factory GetUserFeedsRequestParams.fromJson(Map<String, dynamic> json) => _$GetUserFeedsRequestParamsFromJson(json);
}

@freezed
abstract class GetUserPostsRequestParams with _$GetUserPostsRequestParams {
  const factory GetUserPostsRequestParams({required String id, int? page, int? size}) = _GetUserPostsRequestParams;

  factory GetUserPostsRequestParams.fromJson(Map<String, dynamic> json) => _$GetUserPostsRequestParamsFromJson(json);
}

@freezed
abstract class SearchUserRequestParams with _$SearchUserRequestParams {
  const factory SearchUserRequestParams({required String keyword, String? cursor, int? size}) =
  _SearchUserRequestParams;

  factory SearchUserRequestParams.fromJson(Map<String, dynamic> json) => _$SearchUserRequestParamsFromJson(json);
}
