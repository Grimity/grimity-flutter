import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/enum/report.enum.dart';
import 'package:grimity/presentation/report/provider/report_argument_provider.dart';
import 'package:grimity/presentation/report/report_view.dart';
import 'package:grimity/presentation/report/widget/report_app_bar.dart';
import 'package:grimity/presentation/report/view/report_body_view.dart';
import 'package:grimity/presentation/report/widget/report_send_button.dart';

class ReportPage extends StatelessWidget {
  final ReportRefType refType;
  final String refId;

  const ReportPage({super.key, required this.refType, required this.refId});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        reportRefTypeArgumentProvider.overrideWithValue(refType),
        reportRefIdArgumentProvider.overrideWithValue(refId),
      ],
      child: ReportView(
        reportAppBar: ReportAppBar(),
        reportBodyView: ReportBodyView(),
        reportSendButton: ReportSendButton(),
      ),
    );
  }
}
