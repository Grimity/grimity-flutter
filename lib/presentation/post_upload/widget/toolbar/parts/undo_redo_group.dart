import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/app/config/app_color.dart';
import 'toolbar_buttons.dart';

class UndoRedoGroup extends StatelessWidget {
  const UndoRedoGroup({super.key, required this.controller});

  final QuillController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        IconSquareButton(
          onTap: controller.hasUndo ? controller.undo : null,
          child: Assets.icons.editor.undo.svg(
            colorFilter: controller.hasUndo ? ColorFilter.mode(AppColor.gray700, BlendMode.srcIn) : null,
          ),
        ),
        IconSquareButton(
          onTap: controller.hasRedo ? controller.redo : null,
          child: Assets.icons.editor.redo.svg(
            colorFilter: controller.hasRedo ? ColorFilter.mode(AppColor.gray700, BlendMode.srcIn) : null,
          ),
        ),
      ],
    );
  }
}
