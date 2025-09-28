enum LoginProvider { apple, google, kakao }

extension LoginProviderX on LoginProvider {
  static LoginProvider fromString(String value) {
    switch (value.toUpperCase()) {
      case 'APPLE':
        return LoginProvider.apple;
      case 'GOOGLE':
        return LoginProvider.google;
      case 'KAKAO':
        return LoginProvider.kakao;
      default:
        throw ArgumentError('Unknown LoginProvider: $value');
    }
  }
}
