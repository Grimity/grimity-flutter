import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/entity/notification.dart';
import 'package:grimity/domain/repository/notifications_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetNotificationsUseCase extends NoParamUseCase<Result<List<Notification>>> {
  GetNotificationsUseCase(this._notificationsRepository);

  final NotificationsRepository _notificationsRepository;

  @override
  FutureOr<Result<List<Notification>>> execute() async {
    return await _notificationsRepository.getNotifications();
  }
}
