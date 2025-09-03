import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

// 공백/개행/제로폭 등 제거용
final RegExp _wsLike = RegExp(r'[\s\n\r\u00A0\u1680\u2000-\u200A\u2028\u2029\u202F\u205F\u3000\uFEFF]');

/// Delta 관련 유틸
class DeltaUtil {
  /// Delta → HTML
  static String deltaToHtml(Delta delta) {
    final converter = QuillDeltaToHtmlConverter(delta.toJson());
    return converter.convert();
  }

  /// HTML → Delta
  static Delta htmlToDelta(String html) {
    // FIX: <p> 태그 변환 시 개행 처리 안되는 issue(웹에서 게시글 업로드 시 발생)
    // Ref: https://github.com/kakao/kakao_flutter_sdk/issues/200
    bool shouldInsertANewLine(String localName) => localName == 'p';

    return HtmlToDelta(shouldInsertANewLine: shouldInsertANewLine).convert(html);
  }

  /// Delta → Document
  static Document documentFromDelta(Delta? delta) {
    if (delta == null || delta.isEmpty) {
      return Document();
    }
    return Document.fromDelta(delta);
  }

  /// HTML → DelatOps
  static List<Map<String, dynamic>> htmlToOps(String html) {
    final delta = htmlToDelta(html);
    return List<Map<String, dynamic>>.from(delta.toJson().map((e) => Map<String, dynamic>.from(e)));
  }

  /// Delta에 의미 있는 콘텐츠가 있는지 판단
  static bool hasMeaningfulDeltaContent(Delta delta) {
    if (delta.isEmpty) return false;

    for (final op in delta.toList()) {
      final insert = op.data;

      // 1) 순수 텍스트
      if (insert is String) {
        final stripped = insert.replaceAll(_wsLike, '');
        if (stripped.isNotEmpty) return true;
        continue;
      }

      // 2) 임베드(Map)
      if (insert is Map) {
        final keys = insert.keys.map((e) => e?.toString() ?? '').toSet();
        // 쿼릴/커스텀 임베드 키들 흔하게 쓰는 것들
        if (keys.intersection({'image', 'video', 'mention', 'formula', 'divider', 'embed'}).isNotEmpty) {
          return true;
        }
        // 값에 유효 문자열이 있으면 임베드가 있다고 판단
        if (insert.values.any((v) => v is String && v.trim().isNotEmpty)) {
          return true;
        }
      }
    }
    return false;
  }
}
