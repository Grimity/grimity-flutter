import 'package:dio/dio.dart';
import 'package:grimity/data/model/notification/notification_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'notifications_api.g.dart';

@injectable
@RestApi()
abstract class NotificationsAPI {
  @factoryMethod
  factory NotificationsAPI(Dio dio, {@Named('baseUrl') String baseUrl}) = _NotificationsAPI;

  @GET('/notifications')
  Future<List<NotificationResponse>> getNotifications();

  @PUT('/notifications')
  Future<void> markAllAsRead();

  @DELETE('/notifications')
  Future<void> deleteAllNotifications();

  @PUT('/notifications/{id}')
  Future<void> markNotificationAsRead(@Path('id') String id);

  @DELETE('/notifications/{id}')
  Future<void> deleteNotification(@Path('id') String id);
}
