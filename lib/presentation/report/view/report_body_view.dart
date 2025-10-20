import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/presentation/common/widget/text_field/grimity_text_field.dart';
import 'package:grimity/presentation/common/widget/system/check/grimity_radio_button.dart';
import 'package:grimity/presentation/report/provider/report_provider.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/enum/report.enum.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReportBodyView extends HookConsumerWidget with ReportMixin {
  const ReportBodyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = reportState(ref);
    final notifier = reportNotifier(ref);
    final contentController = useTextEditingController(text: state.content ?? '');
    final contentFocusNode = useFocusNode();

    useEffect(() {
      final text = state.content ?? '';
      if (contentController.text != state.content) {
        contentController.value = contentController.value.copyWith(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
          composing: TextRange.empty,
        );
      }
      return null;
    }, [state.content]);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 24),
              child: Text('신고사유를 선택해주세요', style: AppTypeface.subTitle1.copyWith(color: AppColor.gray700)),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final reportType = ReportType.values[index];
                final selected = state.type == reportType;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReportReasonTile(
                      label: reportType.displayName,
                      selected: selected,
                      onTap: () {
                        notifier.updateType(reportType);
                        if (reportType == ReportType.other) {
                          Future.microtask(() => contentFocusNode.requestFocus());
                        }
                      },
                    ),
                    // 신고 사유 중 기타 선택 시 TextField 활성화
                    if (reportType == ReportType.other && selected) ...[
                      Gap(16),
                      GrimityTextField.normal(
                        controller: contentController,
                        focusNode: contentFocusNode,
                        hintText: '사유를 입력하세요',
                        onChanged: (content) => notifier.updateContent(content),
                        maxLines: 5,
                        maxLength: 100,
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ],
                );
              },
              separatorBuilder: (_, __) => Gap(16),
              itemCount: ReportType.values.length,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportReasonTile extends StatelessWidget {
  const _ReportReasonTile({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        spacing: 12,
        children: [
          GrimityRadioButton(value: selected, onTap: onTap),
          Text(label, style: AppTypeface.body2.copyWith(color: AppColor.gray800)),
        ],
      ),
    );
  }
}
