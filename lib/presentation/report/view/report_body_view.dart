import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:gap/gap.dart';
import 'package:grimity/presentation/report/provider/report_provider.dart';
import 'package:grimity/app/enum/report.enum.dart';
import 'package:grimity/presentation/report/view/report_action_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReportBodyView extends HookConsumerWidget with ReportMixin {
  const ReportBodyView({
    super.key,
    required this.isModal,
  });

  final bool isModal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = reportState(ref);
    final notifier = reportNotifier(ref);
    final contentFocusNode = useFocusNode();

    final Widget child = ListView(
      shrinkWrap: isModal,
      physics: isModal ? NeverScrollableScrollPhysics() : null,
      padding: EdgeInsets.only(
        top: isModal ? GdsSpacing.spacing8 : GdsSpacing.spacing16,
        left: isModal ? 0 : GdsSpacing.spacing16,
        right: isModal ? 0 : GdsSpacing.spacing16,
        bottom: isModal ? GdsSpacing.spacing20 : GdsSpacing.spacing16,
      ),
      children: [
        buildContainer(
          context,
          title: '신고 사유를 선택해주세요',
          isRequired: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...ReportType.values.map((type) {
                final isSelected = state.type == type;

                return GdsListItem.radio(
                  text: type.displayName,
                  state: isSelected ? GdsListItemState.pressed : GdsListItemState.enabled,
                  isZeroPadding: true,
                  onTap: () {
                    notifier.updateType(type);

                    if (type == ReportType.other) {
                      Future.microtask(() => contentFocusNode.requestFocus());
                    }
                  },
                );
              }),
            ],
          ),
        ),
        Gap(context.isMobile ? GdsSpacing.spacing12 : GdsSpacing.spacing20),
        buildContainer(
          context,
          title: '자세한 내용을 알려주세요',
          isRequired: state.type == ReportType.other,
          child: GdsTextArea(
            placeholder: '구체적인 사유를 적어주세요',
            maxLength: 500,
            focusNode: contentFocusNode,
            onChanged: notifier.updateContent,
          ),
        ),
      ],
    );

    if (isModal) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          ReportActionView(isModal: isModal),
        ],
      );
    }

    return Column(
      children: [
        Expanded(child: child),
        ReportActionView(isModal: isModal),
      ],
    );
  }

  static Widget buildContainer(
    BuildContext context, {
    required Widget child,
    required String title,
    required bool isRequired,
  }) {
    final colors = context.gdsColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: GdsSpacing.spacing10,
      children: [
        Row(
          spacing: GdsSpacing.spacing2,
          children: [
            Text(
              '신고 사유를 선택해주세요',
              style: GdsTypography.subtitle2.copyWith(color: colors.text.grayBold),
            ),
            Text(
              isRequired ? '(필수)' : '(선택)',
              style: GdsTypography.subtitle2.copyWith(
                color: isRequired ? colors.text.primaryNormal : colors.text.graySubtle,
              ),
            ),
          ],
        ),
        child,
      ],
    );
  }
}
