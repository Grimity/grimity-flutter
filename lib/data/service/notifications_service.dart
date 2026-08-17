import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/gen/rest_client.dart';
import 'package:grimity/data/mapper/generated_common_mapper.dart';
import 'package:grimity/domain/entity/notification.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NotificationsService {
  final RestClient _client;

  NotificationsService(this._client);

  Future<Result<List<Notification>>> getNotifications() async {
    try {
      final response = await _client.notifications.notificationGetAll();
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> markAllAsRead() async {
    try {
      await _client.notifications.notificationReadAll();
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> deleteAllNotifications() async {
    try {
      await _client.notifications.notificationDeleteAll();
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> markNotificationAsRead(String id) async {
    try {
      await _client.notifications.notificationRead(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> deleteNotification(String id) async {
    try {
      await _client.notifications.notificationDelete(id: id);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
