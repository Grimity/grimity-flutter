import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/enum/subscription_type.enum.dart';

part 'subscription.freezed.dart';
part 'subscription.g.dart';

@freezed
abstract class Subscription with _$Subscription {
  const factory Subscription({required List<SubscriptionType> subscription}) = _Subscription;

  factory Subscription.fromJson(Map<String, dynamic> json) => _$SubscriptionFromJson(json);
}
