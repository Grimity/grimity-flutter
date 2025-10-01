class AppConfig {
  static late final AppConfig _instance;

  final String _baseUrl;
  final String _apiUrl;
  final String _imageUrl;

  AppConfig._({required String baseUrl, required String apiUrl, required String imageUrl})
    : _baseUrl = baseUrl,
      _apiUrl = apiUrl,
      _imageUrl = imageUrl;

  static void initialize({required String baseUrl, required String apiUrl, required String imageUrl}) {
    _instance = AppConfig._(baseUrl: baseUrl, apiUrl: apiUrl, imageUrl: imageUrl);
  }

  static AppConfig get instance => _instance;

  static String get baseUrl => _instance._baseUrl;

  static String get apiUrl => _instance._apiUrl;

  static String get imageUrl => _instance._imageUrl;

  /// FeedUrl (ApiUrl + feeds/ + feedId)
  static String buildFeedUrl(String feedId) => '${instance._baseUrl}feeds/$feedId';

  /// FeedUrl (ApiUrl + posts/ + postId)
  static String buildPostUrl(String postId) => '${instance._baseUrl}posts/$postId';
}
