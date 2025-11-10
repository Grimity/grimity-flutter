import 'package:grimity/app/environment/flavor.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ApiModule {
  @Named('baseUrl')
  String provideBaseUrl(ApiUrlProvider provider) => provider.apiUrl;
}

abstract class ApiUrlProvider {
  String get apiUrl;
}

@Injectable(as: ApiUrlProvider)
class EnvApiUrlProvider implements ApiUrlProvider {
  @override
  String get apiUrl => Flavor.env.apiUrl;
}
