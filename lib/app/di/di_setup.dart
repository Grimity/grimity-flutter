import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di_setup.config.dart';

final getIt = GetIt.instance;

abstract class Env {
  static const String dev = 'dev';
  static const String prod = 'prod';
}

@dev
@injectableInit
Future<void> configureDependenciesDev() async => getIt.init(environment: Env.dev);

@prod
@injectableInit
Future<void> configureDependenciesProd() async => getIt.init(environment: Env.prod);
