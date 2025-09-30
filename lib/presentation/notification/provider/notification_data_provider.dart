import 'package:grimity/domain/entity/notification.dart';
import 'package:grimity/domain/usecase/notifications_usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_data_provider.g.dart';

@riverpod
class NotificationData extends _$NotificationData {
  @override
  FutureOr<List<Notification>> build() async {
    final result = await getNotificationsUseCase.execute();

    return result.fold(onSuccess: (List<Notification> notifications) => notifications, onFailure: (e) => []);
  }

  /// 알림 읽음 처리(성공 가정, 실패시 복원)
  Future<void> markNotificationAsRead(String id) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.isEmpty) {
      return;
    }

    // 원본 상태 보관
    final prevState = currentState;

    // 로컬 반영
    final updated =
        currentState
            .map((notification) => (notification.id == id) ? notification.copyWith(isRead: true) : notification)
            .toList();
    state = AsyncData(updated);

    // 서버 반영
    final result = await markNotificationAsReadUseCase.execute(id);

    // 실패 시 복원
    result.fold(
      onSuccess: (_) {},
      onFailure: (e) {
        state = AsyncData(prevState);
      },
    );
  }

  /// 알림 전체 읽음 처리(성공 가정, 실패시 복원)
  Future<void> markAllNotificationAsRead() async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.isEmpty) {
      return;
    }

    // 원본 상태 보관
    final prevState = currentState;

    // 로컬 반영
    final updated = currentState.map((notification) => notification.copyWith(isRead: true)).toList();
    state = AsyncData(updated);

    // 서버 반영
    final result = await markAllAsReadUseCase.execute();

    // 실패 시 복원
    result.fold(
      onSuccess: (_) {},
      onFailure: (e) {
        state = AsyncData(prevState);
      },
    );
  }

  /// 개별 알림 삭제(성공 가정, 실패시 복원)
  Future<void> deleteNotification(String id) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.isEmpty) {
      return;
    }

    // 원본 상태 보관
    final prevState = currentState;

    // 로컬 반영
    final updated = currentState.where((n) => n.id != id).toList();
    state = AsyncData(updated);

    // 서버 반영
    final result = await deleteNotificationUseCase.execute(id);

    // 실패 시 복원
    result.fold(
      onSuccess: (_) {},
      onFailure: (e) {
        state = AsyncData(prevState);
      },
    );
  }

  /// 전체 알림 삭제(성공 가정, 실패시 복원)
  Future<void> deleteAllNotification() async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.isEmpty) {
      return;
    }

    // 원본 상태 보관
    final prevState = currentState;

    // 로컬 반영
    state = AsyncData(<Notification>[]);

    // 서버 반영
    final result = await deleteAllNotificationsUseCase.execute();

    // 실패 시 복원
    result.fold(
      onSuccess: (_) {},
      onFailure: (e) {
        state = AsyncData(prevState);
      },
    );
  }
}
