import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/post_upload/widget/toolbar/parts/quill_toolbar_utils.dart';
import 'toolbar_buttons.dart';

class TextStyleGroup extends StatelessWidget {
  const TextStyleGroup({super.key, required this.controller, required this.selectionState});

  final QuillController controller;
  final SelectionState selectionState;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        IconSquareButton(
          active: selectionState.isBold,
          onTap: () => controller.toggle(Attribute.bold),
          child: Assets.icons.editor.bold.svg(
            colorFilter: selectionState.isBold ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null,
          ),
        ),
        IconSquareButton(
          active: selectionState.isItalic,
          onTap: () => controller.toggle(Attribute.italic),
          child: Assets.icons.editor.italic.svg(
            colorFilter: selectionState.isItalic ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null,
          ),
        ),
        IconSquareButton(
          active: selectionState.isUnderline,
          onTap: () => controller.toggle(Attribute.underline),
          child: Assets.icons.editor.underline.svg(
            colorFilter: selectionState.isUnderline ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null,
          ),
        ),
        IconSquareButton(
          active: selectionState.isStrike,
          onTap: () => controller.toggle(Attribute.strikeThrough),
          child: Assets.icons.editor.strikethrough.svg(
            colorFilter: selectionState.isStrike ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null,
          ),
        ),
      ],
    );
  }
}
