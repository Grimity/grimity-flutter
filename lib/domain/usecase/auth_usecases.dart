import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/domain/usecase/auth/login_usecase.dart';
import 'package:grimity/domain/usecase/auth/login_with_oauth_usecase.dart';

final loginUseCase = getIt<LoginUseCase>();
final loginWithOAuthUseCase = getIt<LoginWithOAuthUseCase>();
