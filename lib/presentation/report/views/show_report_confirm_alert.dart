import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/report/views/show_report_complete_alert.dart';
import 'package:pervice/pervice.dart';

/// 신고 확인 알림을 표시하고 사용자의 최종 신고 여부를 반환합니다.
Future<void> showReportConfirmAlert(
  BuildContext context,
  PostReports service,
) {
  return GdsAlert.show(
    context,
    builder: (context) {
      final loading = context.stateOf(() => false);

      // 신고를 접수하고 완료 안내 표시.
      void submit() async {
        await loading.run(() async {
          await service.request();

          // 현재 팝업과 신고 페이지를 닫고 신고 접수 완료 안내 표시.
          if (context.mounted) {
            context.pop();
            context.pop();
            showReportCompleteAlert(context);
          }
        });
      }

      return GdsAlert(
        title: '신고하시겠어요?',
        description:
            '신고 접수 후에는 취소가 어려워요.\n'
            '허위 신고 시 서비스 이용이 제한될 수 있어요.',
        primaryButton: .new(
          label: '신고하기',
          onTap: submit,
          status: .from(loading: loading.value),
        ),
        secondaryButton: .new(
          label: '아니요',
          onTap: context.pop,
        ),
      );
    },
  );
}
