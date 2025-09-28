import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/repository/notifications_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class MarkNotificationAsReadUseCase extends UseCase<String, Result<void>> {
  MarkNotificationAsReadUseCase(this._notificationsRepository);

  final NotificationsRepository _notificationsRepository;

  @override
  FutureOr<Result<void>> execute(String id) async {
    return await _notificationsRepository.markNotificationAsRead(id);
  }
}
