class AppConfig {
  static late final AppConfig _instance;

  final String _apiUrl;
  final String _imageUrl;

  AppConfig._({required String apiUrl, required String imageUrl}) : _apiUrl = apiUrl, _imageUrl = imageUrl;

  static void initialize({required String apiUrl, required String imageUrl}) {
    _instance = AppConfig._(apiUrl: apiUrl, imageUrl: imageUrl);
  }

  static AppConfig get instance => _instance;

  static String get apiUrl => _instance._apiUrl;

  static String get imageUrl => _instance._imageUrl;
}
