import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_notification_data_response.freezed.dart';
part 'push_notification_data_response.g.dart';

@freezed
abstract class PushNotificationDataResponse with _$PushNotificationDataResponse {
  factory PushNotificationDataResponse({
    String? data,
    required String event,
    String? deepLink,
  }) = _PushNotificationDataResponse;

  factory PushNotificationDataResponse.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationDataResponseFromJson(json);
}
