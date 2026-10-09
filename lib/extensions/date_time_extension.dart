import 'package:intl/intl.dart';

/// [DateTime]에 대한 유틸리티 확장.
extension DateTimeExtension on DateTime {
  /// 날짜를 yyyy-MM-dd 형식의 문자열로 반환합니다.
  String get yearMonthDay {
    return DateFormat('yyyy-MM-dd').format(this);
  }
}
