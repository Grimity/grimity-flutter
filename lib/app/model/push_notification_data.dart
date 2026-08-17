import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_notification_data.freezed.dart';
part 'push_notification_data.g.dart';

@freezed
abstract class PushNotificationData with _$PushNotificationData {
  const factory PushNotificationData({String? data, required String event, String? deepLink}) = _PushNotificationData;

  factory PushNotificationData.fromJson(Map<String, dynamic> json) => _$PushNotificationDataFromJson(json);
}
