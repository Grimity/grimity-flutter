import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';

class GrimitySelectPopupItem {
  const GrimitySelectPopupItem({
    required this.label,
    required this.onTap,
    this.isSelected = false,
    this.isDisabled = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isDisabled;
}

class GrimitySelectPopup {
  const GrimitySelectPopup({
    required this.title,
    required this.items,
  });

  final String title;
  final List<GrimitySelectPopupItem> items;

  Future<void> show(BuildContext context) {
    final child = Column(
      mainAxisSize: MainAxisSize.min,
      spacing: GdsSpacing.spacing8,
      children: [
        ...items.map((item) {
          GdsListItemState state = GdsListItemState.enabled;
          if (item.isSelected) state = GdsListItemState.pressed;
          if (item.isDisabled) state = GdsListItemState.disabled;

          return GdsListItem.optionCard(
            text: item.label,
            onTap: item.onTap,
            state: state,
          );
        }),
      ],
    );

    if (context.isMobile) {
      final bottomSheet = GdsBottomSheet(
        title: title,
        child: child,
      );

      return bottomSheet.open(context);
    } else {
      final modal = GdsModal(
        title: title,
        body: child,
      );

      return modal.open(context);
    }
  }
}
