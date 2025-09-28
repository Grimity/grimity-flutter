import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/notification.dart';

part 'notification_response.freezed.dart';

part 'notification_response.g.dart';

@Freezed(copyWith: false)
abstract class NotificationResponse with _$NotificationResponse {
  const NotificationResponse._();

  const factory NotificationResponse({
    required String id,
    required DateTime createdAt,
    required bool isRead,
    required String link,
    String? image,
    required String message,
  }) = _NotificationResponse;

  factory NotificationResponse.fromJson(Map<String, dynamic> json) => _$NotificationResponseFromJson(json);
}

extension NotificationResponseX on NotificationResponse {
  Notification toEntity() {
    return Notification(id: id, createdAt: createdAt, isRead: isRead, link: link, message: message, image: image);
  }
}

extension NotificationResponseListX on List<NotificationResponse> {
  List<Notification> toEntity() {
    return map((e) => e.toEntity()).toList();
  }
}
