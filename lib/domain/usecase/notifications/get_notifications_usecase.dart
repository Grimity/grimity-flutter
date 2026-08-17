import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/notification.dart';
import 'package:grimity/data/service/notifications_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetNotificationsUseCase extends NoParamUseCase<Result<List<Notification>>> {
  GetNotificationsUseCase(this._notificationsService);

  final NotificationsService _notificationsService;

  @override
  FutureOr<Result<List<Notification>>> execute() async {
    return await _notificationsService.getNotifications();
  }
}
