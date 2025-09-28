import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/data_source/remote/notifications_api.dart';
import 'package:grimity/data/model/notification/notification_response.dart';
import 'package:grimity/domain/entity/notification.dart';
import 'package:grimity/domain/repository/notifications_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: NotificationsRepository)
class NotificationsRepositoryImpl extends NotificationsRepository {
  final NotificationsAPI _notificationsAPI;

  NotificationsRepositoryImpl(this._notificationsAPI);

  @override
  Future<Result<List<Notification>>> getNotifications() async {
    try {
      final List<NotificationResponse> response = await _notificationsAPI.getNotifications();
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> markAllAsRead() async {
    try {
      await _notificationsAPI.markAllAsRead();
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> deleteAllNotifications() async {
    try {
      await _notificationsAPI.deleteAllNotifications();
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> markNotificationAsRead(String id) async {
    try {
      await _notificationsAPI.markNotificationAsRead(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> deleteNotification(String id) async {
    try {
      await _notificationsAPI.deleteNotification(id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
