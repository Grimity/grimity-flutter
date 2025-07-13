class ValidatorUtil {
  static bool isValidUrl(String url) {
    // 숫자, 영문(소문자), 언더바(_), 2 ~ 12자
    return RegExp(r'^[a-z0-9_]{2,12}$').hasMatch(url);
  }

  static bool isValidNickname(String nickname) {
    // 2 ~ 12자
    return nickname.length >= 2 && nickname.length <= 12;
  }

  static bool isValidAlbumName(String albumName) {
    // 1 ~ 15자
    return albumName.isNotEmpty && albumName.length <= 15;
  }
}
