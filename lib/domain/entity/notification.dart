import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';

part 'notification.g.dart';

@freezed
abstract class Notification with _$Notification {
  const factory Notification({
    required String id,
    required DateTime createdAt,
    required bool isRead,
    required String link,
    String? image,
    required String message,
  }) = _Notification;

  factory Notification.empty() =>
      Notification(id: '', createdAt: DateTime.now(), isRead: false, link: '', message: 'Lorem ipsum dolor sit amet');

  static List<Notification> get emptyList => [Notification.empty(), Notification.empty(), Notification.empty()];

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);
}
