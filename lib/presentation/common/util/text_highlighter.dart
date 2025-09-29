import 'package:flutter/material.dart';

class TextHighlighter {
  static InlineSpan highlight(
      String text,
      List<String> terms, {
        required TextStyle normalStyle,
        required TextStyle highlightStyle,
      }) {
    if (text.isEmpty || terms.isEmpty) {
      return TextSpan(text: text, style: normalStyle);
    }

    final queries = terms
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    if (queries.isEmpty) {
      return TextSpan(text: text, style: normalStyle);
    }

    final ranges = <_Range>[];
    for (final q in queries) {
      final re = RegExp(RegExp.escape(q), caseSensitive: false);
      for (final m in re.allMatches(text)) {
        ranges.add(_Range(m.start, m.end));
      }
    }
    if (ranges.isEmpty) {
      return TextSpan(text: text, style: normalStyle);
    }

    ranges.sort((a, b) => a.start.compareTo(b.start));
    final merged = <_Range>[];
    for (final r in ranges) {
      if (merged.isEmpty) {
        merged.add(r);
      } else {
        final last = merged.last;
        if (r.start <= last.end) {
          merged[merged.length - 1] =
              _Range(last.start, r.end > last.end ? r.end : last.end);
        } else {
          merged.add(r);
        }
      }
    }

    final spans = <TextSpan>[];
    var cursor = 0;
    for (final m in merged) {
      if (cursor < m.start) {
        spans.add(TextSpan(
          text: text.substring(cursor, m.start),
          style: normalStyle,
        ));
      }
      spans.add(TextSpan(
        text: text.substring(m.start, m.end),
        style: highlightStyle,
      ));
      cursor = m.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(
        text: text.substring(cursor),
        style: normalStyle,
      ));
    }

    return TextSpan(children: spans);
  }
}

class _Range {
  final int start;
  final int end;
  const _Range(this.start, this.end);
}
