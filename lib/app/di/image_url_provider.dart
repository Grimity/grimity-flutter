import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

abstract class ImageUrlProvider {
  String get imageUrl;
}

@dev
@Injectable(as: ImageUrlProvider)
class DevImageUrlProvider implements ImageUrlProvider {
  @override
  String get imageUrl => dotenv.env['DEV_IMAGE_URL']!;
}

@prod
@Injectable(as: ImageUrlProvider)
class ProdImageUrlProvider implements ImageUrlProvider {
  @override
  String get imageUrl => dotenv.env['IMAGE_URL']!;
}
