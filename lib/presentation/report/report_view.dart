import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/enum/report.enum.dart';
import 'package:grimity/presentation/report/provider/report_argument_provider.dart';
import 'package:grimity/presentation/report/view/report_body_view.dart';

class ReportView extends StatelessWidget {
  const ReportView({
    super.key,
    required this.refId,
    required this.refType,
    required this.isModal,
  });

  final String refId;
  final ReportRefType refType;
  final bool isModal;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        reportRefIdArgumentProvider.overrideWithValue(refId),
        reportRefTypeArgumentProvider.overrideWithValue(refType),
      ],
      child: ReportBodyView(isModal: isModal),
    );
  }
}
