import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_credential_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthCredential extends _$AuthCredential {
  @override
  AuthCredentialState build() {
    return AuthCredentialState();
  }

  void setCredential(LoginProvider provider, String accessToken) {
    state = AuthCredentialState(provider: provider, providerAccessToken: accessToken);
  }

  void clear() {
    ref.invalidateSelf();
  }
}

class AuthCredentialState {
  final LoginProvider? provider;
  final String? providerAccessToken;

  AuthCredentialState({this.provider, this.providerAccessToken});
}
