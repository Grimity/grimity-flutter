import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:gds/gds.dart';

class AppTypefaceEditor {
  const AppTypefaceEditor({required this.context});

  final BuildContext context;

  TextStyle get paragraph => GdsTypography.label2.copyWith(color: context.gdsColors.text.grayBold);
  TextStyle get h1 => GdsTypography.subtitle1.copyWith(color: context.gdsColors.text.grayBold);
  TextStyle get h2 => GdsTypography.body1SB.copyWith(color: context.gdsColors.text.grayBold);

  static const _pBottom = VerticalSpacing(0, 6);
  static const _hBottom = VerticalSpacing(0, 14);
  static const _lineSpacing = VerticalSpacing.zero;
  static const _hSpacing = HorizontalSpacing.zero;

  DefaultStyles get defaultStyles => DefaultStyles(
    paragraph: DefaultTextBlockStyle(paragraph, _hSpacing, _pBottom, _lineSpacing, null),
    h1: DefaultTextBlockStyle(h1, _hSpacing, _hBottom, _lineSpacing, null),
    h2: DefaultTextBlockStyle(h2, _hSpacing, _hBottom, _lineSpacing, null),
    link: paragraph.copyWith(color: context.gdsColors.text.primaryNormal),
    placeHolder: DefaultTextBlockStyle(
      paragraph.copyWith(color: context.gdsColors.text.graySubtle),
      _hSpacing,
      _pBottom,
      _lineSpacing,
      null,
    ),
  );
}
