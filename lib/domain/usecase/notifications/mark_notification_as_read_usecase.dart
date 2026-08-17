import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/data/service/notifications_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class MarkNotificationAsReadUseCase extends UseCase<String, Result<void>> {
  MarkNotificationAsReadUseCase(this._notificationsService);

  final NotificationsService _notificationsService;

  @override
  FutureOr<Result<void>> execute(String id) async {
    return await _notificationsService.markNotificationAsRead(id);
  }
}
