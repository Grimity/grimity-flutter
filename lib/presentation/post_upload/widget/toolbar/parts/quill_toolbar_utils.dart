import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:grimity/app/util/color_util.dart';

extension QuillControllerX on QuillController {
  SelectionState get currentSelectionState {
    final attrs = getSelectionStyle().attributes;
    final header = attrs[Attribute.header.key];
    final isH1 = header?.value == 1;
    final isH2 = header?.value == 2;

    final textColorAttr = attrs[Attribute.color.key]?.value as String?;
    final bgColorAttr = attrs[Attribute.background.key]?.value as String?;

    return SelectionState(
      isH1: isH1,
      isH2: isH2,
      isNormal: !(isH1 || isH2),
      isBold: attrs.containsKey(Attribute.bold.key),
      isItalic: attrs.containsKey(Attribute.italic.key),
      isUnderline: attrs.containsKey(Attribute.underline.key),
      isStrike: attrs.containsKey(Attribute.strikeThrough.key),
      textColor: ColorUtil.parseHex(textColorAttr),
      backgroundColor: ColorUtil.parseHex(bgColorAttr),
    );
  }

  void toggle(Attribute attribute) {
    final attributes = getSelectionStyle().attributes;
    final already = attributes.containsKey(attribute.key);
    final unset = Attribute(attribute.key, attribute.scope, null);
    formatSelection(already ? unset : attribute);
  }

  void setHeader(Attribute? attribute) {
    if (attribute == null) {
      formatSelection(Attribute(Attribute.header.key, AttributeScope.block, null));
    } else {
      formatSelection(attribute);
    }
  }

  void applyLink(String text, String url) {
    final sel = selection;
    final start = sel.start, end = sel.end;
    if (sel.isCollapsed) {
      final label = (text.trim().isEmpty ? url : text).trim();
      if (label.isEmpty) return;
      replaceText(start, 0, label, TextSelection.collapsed(offset: start + label.length));
      updateSelection(TextSelection(baseOffset: start, extentOffset: start + label.length), ChangeSource.local);
      formatSelection(LinkAttribute(url));
      return;
    }
    final fullText = document.toPlainText();
    final current = fullText.substring(start, end);
    final newLabel = (text.trim().isEmpty ? current : text).trim();

    if (newLabel != current) {
      replaceText(
        start,
        end - start,
        newLabel,
        TextSelection(baseOffset: start, extentOffset: start + newLabel.length),
      );
    } else {
      updateSelection(TextSelection(baseOffset: start, extentOffset: start + newLabel.length), ChangeSource.local);
    }
    formatSelection(LinkAttribute(url));
  }
}

class SelectionState {
  final bool isH1, isH2, isNormal, isBold, isItalic, isUnderline, isStrike;
  final Color? textColor, backgroundColor;

  const SelectionState({
    required this.isH1,
    required this.isH2,
    required this.isNormal,
    required this.isBold,
    required this.isItalic,
    required this.isUnderline,
    required this.isStrike,
    required this.textColor,
    required this.backgroundColor,
  });
}
