import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/enum/report.enum.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_drawer.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_title_top_navigation.dart';
import 'package:grimity/presentation/report/report_view.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({
    super.key,
    required this.refId,
    required this.refType,
  });

  final String refId;
  final ReportRefType refType;

  @override
  Widget build(BuildContext context) {
    return GdsScaffold(
      appBar: GrimityTitleTopNavigation(title: '신고하기', showIcons: false),
      drawer: GrimityDrawer(),
      body: ReportView(refId: refId, refType: refType, isModal: false),
    );
  }

  static Future<T?> push<T>(
    BuildContext context, {
    required String refId,
    required ReportRefType refType,
  }) {
    if (context.isMobile) {
      return ReportRoute(refType: refType, refId: refId).push(context);
    } else {
      final child = ReportView(refId: refId, refType: refType, isModal: true);
      final modal = GdsModal(title: '신고하기', body: child);

      return modal.open(context);
    }
  }
}
