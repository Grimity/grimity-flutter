import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/enum/subscription_type.enum.dart';
import 'package:grimity/domain/entity/subscription.dart';

part 'subscription_response.freezed.dart';
part 'subscription_response.g.dart';

@Freezed(copyWith: false)
abstract class SubscriptionResponse with _$SubscriptionResponse {
  const factory SubscriptionResponse({required List<SubscriptionType> subscription}) = _SubscriptionResponse;

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) => _$SubscriptionResponseFromJson(json);
}

extension SubscriptionResponseX on SubscriptionResponse {
  Subscription toEntity() {
    return Subscription(subscription: subscription);
  }
}
