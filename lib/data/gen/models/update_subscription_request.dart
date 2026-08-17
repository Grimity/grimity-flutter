// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'subscription_type.dart';

part 'update_subscription_request.freezed.dart';
part 'update_subscription_request.g.dart';

@Freezed()
abstract class UpdateSubscriptionRequest with _$UpdateSubscriptionRequest {
  const factory UpdateSubscriptionRequest({
    required List<SubscriptionType> subscription,
  }) = _UpdateSubscriptionRequest;

  factory UpdateSubscriptionRequest.fromJson(Map<String, Object?> json) => _$UpdateSubscriptionRequestFromJson(json);
}
