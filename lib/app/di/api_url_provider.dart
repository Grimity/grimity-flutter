import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

abstract class ApiUrlProvider {
  String get apiUrl;
}

@dev
@Injectable(as: ApiUrlProvider)
class DevApiUrlProvider implements ApiUrlProvider {
  @override
  String get apiUrl => dotenv.env['DEV_API_URL']!;
}

@prod
@Injectable(as: ApiUrlProvider)
class ProdApiUrlProvider implements ApiUrlProvider {
  @override
  String get apiUrl => dotenv.env['API_URL']!;
}
