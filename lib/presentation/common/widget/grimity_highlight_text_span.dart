import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';

/// 특정 키워드 강조 표시 위젯
class GrimityHighlightTextSpan extends StatelessWidget {
  const GrimityHighlightTextSpan({
    super.key,
    required this.text,
    this.keyword,
    required this.normal,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  final String text;
  final String? keyword;
  final TextStyle normal;

  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      buildHighlightedSpan(text: text, keyword: keyword, normal: normal),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  InlineSpan buildHighlightedSpan({required String text, String? keyword, required TextStyle normal}) {
    if (keyword == null || keyword.isEmpty) {
      return TextSpan(text: text, style: normal);
    }

    final kw = keyword.trim();
    final reg = RegExp(RegExp.escape(kw), caseSensitive: false);
    final spans = <TextSpan>[];
    int start = 0;

    for (final m in reg.allMatches(text)) {
      if (m.start > start) {
        spans.add(TextSpan(text: text.substring(start, m.start), style: normal));
      }
      spans.add(TextSpan(text: text.substring(m.start, m.end), style: normal.copyWith(color: AppColor.main)));
      start = m.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: normal));
    }

    return TextSpan(children: spans, style: normal);
  }
}
