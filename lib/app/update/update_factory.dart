import 'dart:io';

import 'package:grimity/app/update/update_service.dart';

class UpdateServiceFactory {
  static UpdateService create() {
    if (Platform.isAndroid) return UpdateServiceAndroid();
    if (Platform.isIOS) return UpdateServiceIOS();
    throw UnsupportedError('Unsupported platform');
  }
}
