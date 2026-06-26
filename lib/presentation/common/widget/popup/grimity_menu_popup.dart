import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';

class GrimityMenuPopup {
  const GrimityMenuPopup({
    required this.layerLink,
    required this.items,
    this.title,
    this.isOption = false,
  });

  final LayerLink layerLink;
  final List<GdsMenuItem> items;
  final String? title;
  final bool isOption;

  Future<void> show(BuildContext context, GdsMenuPosition position) {
    if (context.isMobile) {
      context = rootNavigatorKey.currentContext ?? context;

      final child = Column(
        mainAxisSize: MainAxisSize.min,
        spacing: isOption ? GdsSpacing.spacing8 : 0,
        children: items.map(_buildBottomSheetItem).toList(),
      );

      final bottomSheet = GdsBottomSheet(
        onClose: context.pop,
        title: title ?? '',
        child: child,
      );

      return bottomSheet.open(context);
    } else {
      return GdsMenu(items: [items]).open(
        context,
        position: position,
        layerLink: layerLink,
      );
    }
  }

  Widget _buildBottomSheetItem(GdsMenuItem item) {
    if (isOption) {
      return GdsListItem.optionCard(
        text: item.label,
        state: item.state,
        onTap: item.onTap,
      );
    }

    return GdsListItem.textLarge(
      text: item.label,
      state: item.state,
      isNegative: false,
      onTap: item.onTap,
    );
  }
}
