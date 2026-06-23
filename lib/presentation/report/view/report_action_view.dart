import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/presentation/report/provider/report_provider.dart';
import 'package:grimity/presentation/report/widget/report_confirm_alert.dart';
import 'package:grimity/presentation/report/widget/report_suceess_alert.dart';

class ReportActionView extends ConsumerWidget with ReportMixin {
  const ReportActionView({
    super.key,
    required this.isModal,
  });

  final bool isModal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = reportNotifier(ref);

    final Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      spacing: GdsSpacing.spacing8,
      children: [
        Expanded(
          child: GdsOutlinedButton(
            size: GdsOutlinedButtonSize.large,
            text: '닫기',
            expanded: true,
            onPressed: context.pop,
          ),
        ),
        Expanded(
          child: GdsSolidButton(
            size: GdsSolidButtonSize.large,
            text: '신고하기',
            enabled: notifier.enabled,
            expanded: true,
            onPressed: () async {
              final isAgreed = await showConfirmReportAlert(context);

              // 사용자가 신고하는 것을 최종적으로 동의한 경우
              if (isAgreed ?? false) {
                final isSucceeded = await notifier.sendReport();

                // 사용자가 신고에 최종적으로 성공한 경우
                if (isSucceeded && context.mounted) {
                  showSuccessReportAlert(context);
                }
              }
            },
          ),
        ),
      ],
    );

    if (isModal) return child;

    return Padding(
      padding: EdgeInsets.only(
        top: GdsSpacing.spacing8,
        left: GdsSpacing.spacing16,
        right: GdsSpacing.spacing16,
        bottom: GdsSpacing.spacing24,
      ),
      child: child,
    );
  }
}
