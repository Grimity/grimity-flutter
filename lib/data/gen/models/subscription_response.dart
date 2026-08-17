// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'subscription_response_subscription.dart';

part 'subscription_response.freezed.dart';
part 'subscription_response.g.dart';

@Freezed()
abstract class SubscriptionResponse with _$SubscriptionResponse {
  const factory SubscriptionResponse({
    required List<SubscriptionResponseSubscription> subscription,
  }) = _SubscriptionResponse;

  factory SubscriptionResponse.fromJson(Map<String, Object?> json) => _$SubscriptionResponseFromJson(json);
}
