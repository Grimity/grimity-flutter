// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/report/views/show_report_complete_alert.dart';

/// 신고 확인 알림을 표시하고 사용자의 최종 신고 여부를 반환합니다.
Future<void> showReportConfirmAlert(
  BuildContext context,
  PostReports service,
) {
  return GdsAlert.show(
    context,
    builder: (context) {
      // 신고를 접수하고 완료 안내 표시.
      Future<void> submit() async {
        await service.request();

        // 현재 팝업과 신고 페이지를 닫고 완료 안내 표시.
        if (context.mounted) {
          context.pop();
          context.pop();
          showReportCompleteAlert(context);
        }
      }

      return GdsAlert(
        title: '신고하시겠어요?',
        description:
            '신고 접수 후에는 취소가 어려워요.\n'
            '허위 신고 시 서비스 이용이 제한될 수 있어요.',
        primaryButton: .new(
          label: '신고하기',
          onTap: submit,
        ),
        secondaryButton: .new(
          label: '아니요',
          onTap: context.pop,
        ),
      );
    },
  );
}
