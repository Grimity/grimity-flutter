import 'package:injectable/injectable.dart';
import 'api_url_provider.dart';

@module
abstract class ApiModule {
  @Named('baseUrl')
  String provideBaseUrl(ApiUrlProvider provider) => provider.apiUrl;
}
