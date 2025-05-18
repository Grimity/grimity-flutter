import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/domain/usecase/auth/complete_login_process_usecase.dart';
import 'package:grimity/domain/usecase/auth/complete_logout_process_usecase.dart';
import 'package:grimity/domain/usecase/auth/load_token_usecase.dart';
import 'package:grimity/domain/usecase/auth/login_usecase.dart';
import 'package:grimity/domain/usecase/auth/login_with_oauth_usecase.dart';
import 'package:grimity/domain/usecase/auth/logout_with_oauth_usecase.dart';
import 'package:grimity/domain/usecase/auth/update_token_usecase.dart';

final completeLoginProcessUseCase = getIt<CompleteLoginProcessUseCase>();
final loginUseCase = getIt<LoginUseCase>();
final loginWithOAuthUseCase = getIt<LoginWithOAuthUseCase>();

final completeLogoutProcessUseCase = getIt<CompleteLogoutProcessUseCase>();
final logoutWithOAuthUseCase = getIt<LogoutWithOAuthUseCase>();

final loadTokenUseCase = getIt<LoadTokenUseCase>();
final updateTokenUseCase = getIt<UpdateTokenUseCase>();

class LoginRequestParam {
  final String provider;
  final String providerAccessToken;

  LoginRequestParam({required this.provider, required this.providerAccessToken});

  Map<String, dynamic> toJson() {
    return {'provider': provider, 'providerAccessToken': providerAccessToken};
  }
}
