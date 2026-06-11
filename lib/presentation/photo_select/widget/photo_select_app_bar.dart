import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/presentation/photo_select/provider/photo_select_provider.dart';

class PhotoSelectAppBar extends ConsumerWidget with PhotoSelectMixin {
  const PhotoSelectAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return photosAsync(ref).maybeWhen(
      data: (state) {
        if (!state.hasAccess) {
          return _buildCloseNavigation(context);
        }

        final isActive = state.selected.isNotEmpty;

        return GdsTopNavigation.editor(
          title: '최근 항목',
          label: '다음',
          onBack: () => context.pop(),
          onTitle: () {},
          onSave: () => photoNotifier(ref).completeImageSelect(context),
          saveEnabled: isActive,
        );
      },
      orElse: () => _buildCloseNavigation(context),
    );
  }

  /// GdsTopNavigation에 '닫기'만 있는 타입이 없어 기존 닫기 동작을 유지합니다.
  Widget _buildCloseNavigation(BuildContext context) {
    final colors = context.gdsColors;

    return Padding(
      padding: const EdgeInsets.all(GdsSpacing.spacing16),
      child: Row(
        children: [
          GdsGesture(
            onTap: () => context.pop(),
            child: GdsIcon.xMark.build(color: colors.icon.grayBold, width: 24, height: 24),
          ),
        ],
      ),
    );
  }
}
