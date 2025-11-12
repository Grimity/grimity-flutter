import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/domain/usecase/system/get_app_version_usecase.dart';
import 'package:grimity/domain/usecase/system/healthcheck_usecase.dart';

final healthCheckUseCase = getIt<HealthCheckUseCase>();
final getAppVersionUseCase = getIt<GetAppVersionUseCase>();
