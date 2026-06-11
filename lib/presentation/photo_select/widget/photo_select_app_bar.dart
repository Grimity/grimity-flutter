import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/presentation/photo_select/provider/photo_select_provider.dart';
import 'package:grimity/presentation/photo_select/state/photo_select_state.dart';

class PhotoSelectAppBar extends ConsumerWidget with PhotoSelectMixin {
  const PhotoSelectAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return photosAsync(ref).maybeWhen(
      data: (state) {
        if (!state.hasAccess) {
          return _buildCloseNavigation(context);
        }

        return _buildEditorNavigation(context, ref, state);
      },
      orElse: () => _buildCloseNavigation(context),
    );
  }

  /// 앨범명 + 펼침 화살표를 가진 에디터형 상단 내비게이션.
  /// GdsTopNavigation.editor는 화살표 방향(아래)이 고정이라 앨범 펼침 상태를
  /// 반영하기 위해 동일한 레이아웃을 GDS 토큰으로 직접 구성합니다.
  Widget _buildEditorNavigation(BuildContext context, WidgetRef ref, PhotoSelectState state) {
    final colors = context.gdsColors;
    final isActive = state.selected.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(GdsSpacing.spacing16),
      child: Row(
        spacing: GdsSpacing.spacing8,
        children: [
          GdsGesture(
            onTap: () => context.pop(),
            child: GdsIcon.chevronLeft.build(color: colors.icon.grayBold),
          ),
          Expanded(
            child: GdsGesture(
              onTap: () => photoNotifier(ref).toggleAlbumList(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: GdsSpacing.spacing4,
                children: [
                  Flexible(
                    child: Text(
                      state.albumName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GdsTypography.subtitle2.copyWith(color: colors.text.grayBold),
                    ),
                  ),
                  (state.isAlbumListExpanded ? GdsIcon.chevronUp : GdsIcon.chevronDown).build(
                    color: colors.icon.grayBold,
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          GdsTextButton(
            text: '다음',
            onPressed: () => photoNotifier(ref).completeImageSelect(context),
            enabled: isActive,
          ),
        ],
      ),
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
