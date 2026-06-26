import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/enum/sort_type.enum.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_menu_popup.dart';
import 'package:grimity/presentation/profile/enum/profile_view_type_enum.dart';
import 'package:grimity/presentation/profile/provider/profile_view_type_argument_provider.dart';
import 'package:grimity/presentation/profile/provider/selected_sort_type_provider.dart';

class ProfileSortHeader extends ConsumerWidget {
  const ProfileSortHeader({
    super.key,
    required this.itemCount,
    required this.sortItems,
    required this.sortValue,
    required this.isSortEnabled,
    required this.albumOrganize,
  });

  final int itemCount;
  final List<SortType> sortItems;
  final SortType sortValue;
  final bool isSortEnabled;
  final bool albumOrganize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.gdsColors;
    final viewType = ref.watch(profileViewTypeArgumentProvider);
    final user = ref.read(userAuthProvider);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('게시물', style: GdsTypography.label4.copyWith(color: colors.surface.grayNormal)),
              Gap(GdsSpacing.spacing2),
              Text(
                itemCount.toString(),
                style: GdsTypography.label4.copyWith(color: colors.surface.grayBold),
              ),
              Text('건', style: GdsTypography.label4.copyWith(color: colors.surface.grayNormal)),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: GdsSpacing.spacing8,
            children: [
              if (albumOrganize && viewType == ProfileViewType.mine) ...[
                GdsTextButton(
                  variant: GdsTextButtonVariant.assistive,
                  enabled: (user?.feedCount ?? 0) != 0,
                  text: '그림 정리',
                  trailingIcon: GdsIcon.sortHorizontal,
                  onPressed: () => context.push(AlbumOrganizeRoute.path, extra: user),
                ),
              ],
              GdsMenuAnchor(
                builder: (link) {
                  return GdsFilter(
                    type: GdsFilterType.text,
                    text: sortValue.displayName,
                    enabled: isSortEnabled,
                    onTap: () => showSortMenuPopup(context, ref, link),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> showSortMenuPopup(
    BuildContext context,
    WidgetRef ref,
    LayerLink layerLink,
  ) {
    final popup = GrimityMenuPopup(
      layerLink: layerLink,
      isOption: true,
      title: '정렬',
      items: [
        ...sortItems.map((item) {
          return GdsMenuItem(
            label: item.displayName,
            state: sortValue == item ? GdsListItemState.pressed : GdsListItemState.enabled,
            onTap: () {
              context.pop();
              ref.read(selectedSortTypeProvider.notifier).setSortType(item);
            },
          );
        }),
      ],
    );

    return popup.show(context, GdsMenuPosition.right);
  }
}
