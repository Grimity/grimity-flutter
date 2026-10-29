/// [String]에 대한 유틸리티 확장.
extension StringExtension on String {
  /// 이메일 주소인지 여부.
  bool get isEmail {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(this);
  }
}
