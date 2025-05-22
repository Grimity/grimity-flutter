import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/domain/usecase/auth/remove_token_usecase.dart';
import 'package:grimity/domain/usecase/auth/complete_login_process_usecase.dart';
import 'package:grimity/domain/usecase/auth/complete_logout_process_usecase.dart';
import 'package:grimity/domain/usecase/auth/complete_register_usecase.dart';
import 'package:grimity/domain/usecase/auth/load_token_usecase.dart';
import 'package:grimity/domain/usecase/auth/login_usecase.dart';
import 'package:grimity/domain/usecase/auth/login_with_oauth_usecase.dart';
import 'package:grimity/domain/usecase/auth/logout_usecase.dart';
import 'package:grimity/domain/usecase/auth/logout_with_oauth_usecase.dart';
import 'package:grimity/domain/usecase/auth/refresh_token_usecase.dart';
import 'package:grimity/domain/usecase/auth/register_usecase.dart';
import 'package:grimity/domain/usecase/auth/update_token_usecase.dart';

final completeLoginProcessUseCase = getIt<CompleteLoginProcessUseCase>();
final loginUseCase = getIt<LoginUseCase>();
final loginWithOAuthUseCase = getIt<LoginWithOAuthUseCase>();

final completeLogoutProcessUseCase = getIt<CompleteLogoutProcessUseCase>();
final logoutUseCase = getIt<LogoutUseCase>();
final logoutWithOAuthUseCase = getIt<LogoutWithOAuthUseCase>();

final completeRegisterUseCase = getIt<CompleteRegisterUseCase>();
final registerUseCase = getIt<RegisterUseCase>();

final refreshTokenUseCase = getIt<RefreshTokenUseCase>();

final loadTokenUseCase = getIt<LoadTokenUseCase>();
final removeTokenUseCase = getIt<RemoveTokenUseCase>();
final updateTokenUseCase = getIt<UpdateTokenUseCase>();
