import 'package:grimity/app/base/result.dart';
import 'package:grimity/domain/entity/notification.dart';

abstract class NotificationsRepository {
  Future<Result<List<Notification>>> getNotifications();

  Future<Result<void>> markAllAsRead();

  Future<Result<void>> deleteAllNotifications();

  Future<Result<void>> markNotificationAsRead(String id);

  Future<Result<void>> deleteNotification(String id);
}
