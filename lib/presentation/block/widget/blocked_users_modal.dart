import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/block/view/blocked_users_view.dart';

/// 차단한 사용자 목록을 모달 형태로 표시합니다.
Future<T?> showBlockedUsersModal<T>(BuildContext context) {
  final modal = GdsModal(
    title: '차단',
    body: BlockedUsersView(isModal: true),
  );

  return modal.open(context, isBarrierDismissible: true);
}
