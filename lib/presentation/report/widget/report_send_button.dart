import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/common/widget/button/grimity_button.dart';
import 'package:grimity/presentation/report/provider/report_provider.dart';
import 'package:grimity/presentation/report/widget/report_suceess_dialog.dart';

class ReportSendButton extends ConsumerWidget with ReportMixin {
  const ReportSendButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = reportState(ref);
    final notifier = reportNotifier(ref);
    final buttonEnabled = state.uploading == false && state.type != null;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: GrimityButton.large(
        text: '신고하기',
        onTap: () async {
          final result = await notifier.sendReport();
          if (result && context.mounted) {
            showSuccessReportDialog(context);
          }
        },
        status: buttonEnabled ? ButtonStatus.on : ButtonStatus.off,
      ),
    );
  }
}
