import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di_setup.config.dart';

final getIt = GetIt.instance;

@injectableInit
Future<void> configureDependencies(String environment) async => getIt.init(environment: environment);
