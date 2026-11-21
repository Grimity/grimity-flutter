// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:pervice/pervice.dart';

/// 알림 유형별 수신 여부를 확인하고 변경하는 설정 페이지.
class SettingsNotification extends StatelessWidget with GdsListDetailPage {
  const new({super.key});

  @override
  GdsIcon get icon => .bell;

  @override
  String get title => '알림';

  /// 구독 가능한 모든 알림 유형 목록.
  static final types = SubscriptionType.values.toList();

  @override
  Widget build(BuildContext context) {
    final service = context.serviceOf(GetMeSubscribe.new);

    return service.page(
      loaded: (data) {
        // 현재 구독 중인 알림 유형 목록.
        final subscriptions = context.stateOf(
          () => data.subscription.builder(SubscriptionType.codec.decode),
        );

        return ListView(
          children: [
            controlItem(
              type: null,
              label: '모든 알림',
              subscriptions: subscriptions,
            ),
            controlItem(
              type: .follow,
              label: '팔로우 알림',
              subscriptions: subscriptions,
            ),

            GdsListItem.section(label: '그림'),
            controlItem(
              type: .feedLike,
              label: '좋아요 알림',
              subscriptions: subscriptions,
            ),
            controlItem(
              type: .feedComment,
              label: '새 댓글 알림',
              subscriptions: subscriptions,
            ),
            controlItem(
              type: .feedReply,
              label: '새 답글 알림',
              subscriptions: subscriptions,
            ),

            GdsListItem.section(label: '자유게시판'),
            controlItem(
              type: .postComment,
              label: '새 댓글 알림',
              subscriptions: subscriptions,
            ),
            controlItem(
              type: .postReply,
              label: '새 답글 알림',
              subscriptions: subscriptions,
            ),
          ],
        );
      },
    );
  }

  /// 구독 상태에 따라 전체 또는 개별 알림 토글 항목을 구성합니다.
  Widget controlItem({
    required SubscriptionType? type,
    required String label,
    required ValueState<List<SubscriptionType>> subscriptions,
  }) {
    // 모든 알림을 구독 중인지 여부.
    final isAll = types.length == subscriptions.value.length;

    // 전체 또는 해당 알림을 구독 중인지 확인.
    final isSelected = type == null ? isAll : subscriptions.value.contains(type);

    return GdsControlItem.toggle(
      variant: .normal,
      status: .from(selected: isSelected),
      label: label,
      onTap: () async {
        final oldValues = subscriptions.value.toList();

        // 개별 알림은 해당 항목을, 전체 알림은 모든 항목을 토글.
        if (type != null) {
          isSelected //
              ? subscriptions.value.remove(type)
              : subscriptions.value.add(type);
        } else {
          isSelected //
              ? subscriptions.value.clear()
              : subscriptions.value = types;
        }

        try {
          subscriptions.notifyChanged();
          await submit(subscriptions.value);
        } catch (_) {
          subscriptions.value = oldValues;
          rethrow;
        }
      },
    );
  }

  /// 선택한 알림 수신 설정을 반영합니다.
  Future<void> submit(List<SubscriptionType> subscriptions) async {
    final service = PutMeSubscribe(
      request: .new(subscription: subscriptions),
    );

    await service.request();
  }
}
