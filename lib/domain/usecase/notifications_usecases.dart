import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/domain/usecase/notifications/delete_all_notification_usecase.dart';
import 'package:grimity/domain/usecase/notifications/delete_notification_usecase.dart';
import 'package:grimity/domain/usecase/notifications/get_notifications_usecase.dart';
import 'package:grimity/domain/usecase/notifications/mark_all_as_read_usecase.dart';
import 'package:grimity/domain/usecase/notifications/mark_notification_as_read_usecase.dart';

final getNotificationsUseCase = getIt<GetNotificationsUseCase>();
final markAllAsReadUseCase = getIt<MarkAllAsReadUseCase>();
final deleteAllNotificationsUseCase = getIt<DeleteAllNotificationUseCase>();
final markNotificationAsReadUseCase = getIt<MarkNotificationAsReadUseCase>();
final deleteNotificationUseCase = getIt<DeleteNotificationUseCase>();
