/// 사용자에 의한 로그인 취소 예외
class LoginCanceledException implements Exception {
  const LoginCanceledException([this.message = 'Login canceled by user']);

  final String message;

  @override
  String toString() => 'LoginCanceledException: $message';
}
