import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';

class GrimityMenuPopup {
  const GrimityMenuPopup({
    required this.layerLink,
    required this.items,
  });

  final LayerLink layerLink;
  final List<GdsMenuItem> items;

  Future<void> show(BuildContext context, GdsMenuPosition position) {
    if (context.isMobile) {
      final child = Column(
        mainAxisSize: MainAxisSize.min,
        children: items.map(_buildBottomSheetItem).toList(),
      );

      final bottomSheet = GdsBottomSheet(
        title: '',
        onClose: context.pop,
        child: child,
      );

      return bottomSheet.open(context);
    } else {
      return GdsMenu(items: [items]).open(
        context,
        layerLink: layerLink,
        position: position,
      );
    }
  }

  static Widget _buildBottomSheetItem(GdsMenuItem item) {
    return GdsListItem.textLarge(
      text: item.label,
      state: GdsListItemState.enabled,
      isNegative: false,
      onTap: item.onTap,
    );
  }
}
