import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toRelativeTime() {
    final now = DateTime.now();
    final diff = now.difference(this);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}분 전';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}시간 전';
    }
    if (diff.inDays < 30) {
      return '${diff.inDays}일 전';
    }
    if (diff.inDays < 365) {
      return '${diff.inDays ~/ 30}달 전';
    }
    return '${diff.inDays ~/ 365}년 전';
  }

  /// 기준으로부터 1주일 전 날짜 (yyyy-MM-dd) 반환
  String get oneWeekBeforeFormatted {
    final start = DateTime(year, month, day).subtract(Duration(days: 7));
    return DateFormat('yyyy-MM-dd').format(start);
  }

  /// yyyy-MM-dd 형식 문자열 반환
  String get toYearMonthDay => DateFormat('yyyy-MM-dd').format(this);

  /// yyyy-MM 형식 문자열 반환
  String get toYearMonth => DateFormat('yyyy-MM').format(this);

  /// M월 형식 문자열 반환 (예: 1월, 2월)
  String get toMonthText => '${DateFormat('M').format(this)}월';

  /// 같은 날짜인지 비교
  bool isSameDay(DateTime other) => year == other.year && month == other.month && day == other.day;

  /// 같은 달인지 비교
  bool isSameMonth(DateTime other) => year == other.year && month == other.month;
}
