import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/post_upload/widget/toolbar/parts/menu_archor_square.dart';
import 'package:grimity/presentation/post_upload/widget/toolbar/parts/quill_toolbar_utils.dart';

class HeaderMenu extends StatelessWidget {
  const HeaderMenu({super.key, required this.controller, required this.selectionState});

  final QuillController controller;
  final SelectionState selectionState;

  @override
  Widget build(BuildContext context) {
    return MenuAnchorSquare(
      icon: Assets.icons.editor.head.svg(),
      menuChildren: [
        _headerItem('제목1', selectionState.isH1, () => controller.setHeader(Attribute.h1)),
        _headerItem('제목2', selectionState.isH2, () => controller.setHeader(Attribute.h2)),
        _headerItem('본문', selectionState.isNormal, () => controller.setHeader(null)),
      ],
    );
  }

  MenuItemButton _headerItem(String label, bool selected, VoidCallback onTap) {
    return MenuItemButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((_) => selected ? AppColor.main.withValues(alpha: 0.1) : null),
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.pressed) ? AppColor.gray200 : null,
        ),
      ),
      onPressed: onTap,
      child: Container(
        width: 96,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        child: Text(label, style: TextStyle(fontSize: label == '제목1' ? 18.sp : 16.sp, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
