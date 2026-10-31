// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/report/views/show_report_confirm_alert.dart';
import 'package:grimity/presentation/report/widgets/report_section.dart';
import 'package:pervice/pervice.dart';

/// 신고 사유와 상세 내용을 입력받아 제출하는 페이지.
class ReportPage extends GdsAdaptivePage {
  const new({
    super.key,
    required this.refId,
    required this.refType,
  });

  final String refId;
  final ReportRefType refType;

  @override
  String get title => '신고하기';

  @override
  GdsAdaptiveContent build(BuildContext context) {
    final type = context.stateOf<ReportType?>(() => null);
    final content = context.stateOf(() => '');
    final canSubmit = type.value != null;

    // 신고 여부를 확인한 뒤 신고를 제출하고 완료 안내 표시.
    void submit() {
      showReportConfirmAlert(
        context,
        PostReports(
          request: .new(
            type: type.value!,
            refId: refId,
            refType: refType,
          ),
        ),
      );
    }

    return .new(
      primaryButton: .new(
        label: '신고하기',
        onTap: submit,
        enabled: canSubmit,
      ),
      secondaryButton: .new(
        label: '닫기',
        onTap: context.pop,
      ),
      child: Column(
        mainAxisSize: .min,
        spacing: 12,
        children: [
          ReportSection(
            required: true,
            title: '신고 사유를 선택해주세요',
            child: Column(
              mainAxisSize: .min,

              // 신고 유형별 선택 항목 표시.
              children: ReportType.values.builder((value) {
                return GdsListItem.radio(
                  label: value.key,
                  onTap: () => type.value = value,
                  status: .from(selected: type.value == value),
                );
              }),
            ),
          ),

          // 신고 상세 내용 입력 영역 표시.
          ReportSection(
            required: false,
            title: '자세한 내용을 알려주세요',
            child: GdsTextArea(
              variant: .normal,
              maxLength: 500,
              onChanged: content.setter,
              placeholder: '구체적인 사유를 적어주세요',
            ),
          ),
        ],
      ),
    );
  }
}
