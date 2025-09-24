import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/enum/subscription_type.enum.dart';
import 'package:grimity/domain/entity/link.dart';

part 'me_request_params.freezed.dart';

part 'me_request_params.g.dart';

@freezed
abstract class UpdateUserRequest with _$UpdateUserRequest {
  const factory UpdateUserRequest({
    required String name,
    required String url,
    required String description,
    required List<Link> links,
  }) = _UpdateUserRequest;

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) => _$UpdateUserRequestFromJson(json);
}

@freezed
abstract class UpdateProfileImageRequestParam with _$UpdateProfileImageRequestParam {
  const factory UpdateProfileImageRequestParam({required String imageName}) = _UpdateProfileImageRequestParam;

  factory UpdateProfileImageRequestParam.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileImageRequestParamFromJson(json);
}

@freezed
abstract class UpdateBackgroundImageRequestParam with _$UpdateBackgroundImageRequestParam {
  const factory UpdateBackgroundImageRequestParam({required String imageName}) = _UpdateBackgroundImageRequestParam;

  factory UpdateBackgroundImageRequestParam.fromJson(Map<String, dynamic> json) =>
      _$UpdateBackgroundImageRequestParamFromJson(json);
}

@freezed
abstract class UpdateSubscriptionRequestParam with _$UpdateSubscriptionRequestParam {
  const factory UpdateSubscriptionRequestParam({required List<SubscriptionType> subscription}) =
      _UpdateSubscriptionRequestParam;

  factory UpdateSubscriptionRequestParam.fromJson(Map<String, dynamic> json) =>
      _$UpdateSubscriptionRequestParamFromJson(json);
}
