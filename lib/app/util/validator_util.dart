class ValidatorUtil {
  static List<String> forbiddenUrls = [
    "popular",
    "board",
    "following",
    "search",
    "write",
    "posts",
    "feeds",
    "mypage",
    "ranking",
    "direct",
    "admin",
    "home",
    "sign-in",
    "sign-up",
    "splash",
    "setting",
    "notification",
    "report",
    "storage",
    "follow",
    "album-edit",
    "profile-edit",
    "crop-image",
    "feed-upload",
    "post-upload",
    "photo-select",
    "image-viewer",
    "album-organize",
    "blocked-users",
    "chatMessage",
    "newChat",
    "boardSearch",
  ];

  static bool isAvailableUrl(String url) {
    return isValidUrl(url) && !isForbiddenUrl(url);
  }

  static bool isForbiddenUrl(String url) {
    return forbiddenUrls.contains(url);
  }

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
