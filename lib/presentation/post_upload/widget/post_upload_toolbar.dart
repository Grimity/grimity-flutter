import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/util/color_util.dart';
import 'package:grimity/presentation/common/enum/upload_image_type.dart';
import 'package:grimity/presentation/post_upload/provider/post_upload_page_argument_provider.dart';
import 'package:grimity/presentation/post_upload/provider/post_upload_provider.dart';
import 'package:grimity/presentation/post_upload/widget/post_add_link_bottom_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostUploadToolbar extends HookConsumerWidget {
  const PostUploadToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quillController = ref.watch(postUploadQuillControllerArgumentProvider);
    useListenable(quillController);

    final editorType = useState(GdsEditorType.none);
    final selectionState = quillController.currentSelectionState;
    final fontStyle = _fontStyleFromSelection(selectionState);
    final fontColor = _editorColorFromColor(selectionState.textColor);
    final fontBgColor = _editorColorFromColor(selectionState.backgroundColor);

    return GdsEditor(
      type: editorType.value,
      fontStyle: fontStyle,
      fontColor: fontColor,
      fontBgColor: fontBgColor,
      isBoldPressed: selectionState.isBold,
      isItalicPressed: selectionState.isItalic,
      isUnderlinePressed: selectionState.isUnderline,
      isStrikethroughPressed: selectionState.isStrike,
      onPlus: () => _togglePanel(editorType, GdsEditorType.plus),
      onUndo: quillController.hasUndo ? quillController.undo : null,
      onRedo: quillController.hasRedo ? quillController.redo : null,
      onFontSize: () => _togglePanel(editorType, GdsEditorType.fontStyle),
      onBold: () => quillController.toggle(Attribute.bold),
      onItalic: () => quillController.toggle(Attribute.italic),
      onUnderline: () => quillController.toggle(Attribute.underline),
      onStrikethrough: () => quillController.toggle(Attribute.strikeThrough),
      onFontColor: () => _togglePanel(editorType, GdsEditorType.fontColor),
      onFontBgColor: () => _togglePanel(editorType, GdsEditorType.fontBgColor),
      onKeyboard: () {
        editorType.value = GdsEditorType.none;
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onImageUpload: () async {
        await PhotoSelectRoute(type: UploadImageType.post).push(context);

        if (context.mounted) {
          ref.read(postUploadProvider.notifier).insertImage(controller: quillController);
          editorType.value = GdsEditorType.none;
        }
      },
      onAddLink: () {
        _showLinkPopup(context, quillController);
        editorType.value = GdsEditorType.none;
      },
      onFontStyleChanged: (style) {
        quillController.setHeader(_headerAttributeFromFontStyle(style));
        editorType.value = GdsEditorType.none;
      },
      onFontColorChanged: (color) {
        quillController.formatSelection(ColorAttribute(_nextColorValue(color, fontColor)));
        editorType.value = GdsEditorType.none;
      },
      onFontBgColorChanged: (color) {
        quillController.formatSelection(BackgroundAttribute(_nextColorValue(color, fontBgColor)));
        editorType.value = GdsEditorType.none;
      },
    );
  }

  void _togglePanel(ValueNotifier<GdsEditorType> editorType, GdsEditorType nextType) {
    editorType.value = editorType.value == nextType ? GdsEditorType.none : nextType;
  }

  GdsEditorFontStyle _fontStyleFromSelection(_SelectionState selectionState) {
    if (selectionState.isH1) return GdsEditorFontStyle.title1;
    if (selectionState.isH2) return GdsEditorFontStyle.title2;
    return GdsEditorFontStyle.body;
  }

  Attribute? _headerAttributeFromFontStyle(GdsEditorFontStyle style) {
    return switch (style) {
      GdsEditorFontStyle.title1 => Attribute.h1,
      GdsEditorFontStyle.title2 => Attribute.h2,
      GdsEditorFontStyle.body => null,
    };
  }

  GdsEditorColor? _editorColorFromColor(Color? color) {
    if (color == null) return null;

    for (final editorColor in GdsEditorColor.values) {
      if (editorColor.color.equalsHexCode(color)) {
        return editorColor;
      }
    }

    return null;
  }

  String? _nextColorValue(GdsEditorColor selectedColor, GdsEditorColor? currentColor) {
    return selectedColor == currentColor ? null : selectedColor.color.toHexColor();
  }

  void _showLinkPopup(BuildContext context, QuillController controller) {
    final selection = controller.selection;
    final fullText = controller.document.toPlainText();
    final selectedText = selection.isCollapsed ? '' : fullText.substring(selection.start, selection.end);
    final currentUrl = controller.getSelectionStyle().attributes[Attribute.link.key]?.value as String?;

    showPostAddLinkPopup(
      context,
      initialText: selectedText,
      initialUrl: currentUrl,
      onSubmit: (text, url) => controller.applyLink(text, url),
    );
  }
}

extension _QuillControllerX on QuillController {
  _SelectionState get currentSelectionState {
    final attributes = getSelectionStyle().attributes;
    final header = attributes[Attribute.header.key];
    final isH1 = header?.value == 1;
    final isH2 = header?.value == 2;

    final textColor = attributes[Attribute.color.key]?.value as String?;
    final backgroundColor = attributes[Attribute.background.key]?.value as String?;

    return _SelectionState(
      isH1: isH1,
      isH2: isH2,
      isBold: attributes.containsKey(Attribute.bold.key),
      isItalic: attributes.containsKey(Attribute.italic.key),
      isUnderline: attributes.containsKey(Attribute.underline.key),
      isStrike: attributes.containsKey(Attribute.strikeThrough.key),
      textColor: ColorUtil.parseHex(textColor),
      backgroundColor: ColorUtil.parseHex(backgroundColor),
    );
  }

  void toggle(Attribute attribute) {
    final attributes = getSelectionStyle().attributes;
    final unsetAttribute = Attribute(attribute.key, attribute.scope, null);
    formatSelection(attributes.containsKey(attribute.key) ? unsetAttribute : attribute);
  }

  void setHeader(Attribute? attribute) {
    formatSelection(attribute ?? Attribute(Attribute.header.key, AttributeScope.block, null));
  }

  void applyLink(String text, String url) {
    final selection = this.selection;
    final start = selection.start;
    final end = selection.end;

    if (selection.isCollapsed) {
      final label = (text.trim().isEmpty ? url : text).trim();
      if (label.isEmpty) return;

      replaceText(start, 0, label, TextSelection.collapsed(offset: start + label.length));
      updateSelection(TextSelection(baseOffset: start, extentOffset: start + label.length), ChangeSource.local);
      formatSelection(LinkAttribute(url));
      return;
    }

    final fullText = document.toPlainText();
    final currentText = fullText.substring(start, end);
    final label = (text.trim().isEmpty ? currentText : text).trim();

    if (label != currentText) {
      replaceText(start, end - start, label, TextSelection(baseOffset: start, extentOffset: start + label.length));
    } else {
      updateSelection(TextSelection(baseOffset: start, extentOffset: start + label.length), ChangeSource.local);
    }

    formatSelection(LinkAttribute(url));
  }
}

class _SelectionState {
  const _SelectionState({
    required this.isH1,
    required this.isH2,
    required this.isBold,
    required this.isItalic,
    required this.isUnderline,
    required this.isStrike,
    required this.textColor,
    required this.backgroundColor,
  });

  final bool isH1;
  final bool isH2;
  final bool isBold;
  final bool isItalic;
  final bool isUnderline;
  final bool isStrike;
  final Color? textColor;
  final Color? backgroundColor;
}
