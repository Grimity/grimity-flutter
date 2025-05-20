import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/enum/grimity.enum.dart';
import 'package:grimity/app/util/validator_util.dart';
import 'package:grimity/domain/dto/auth_request_params.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/usecase/auth_usecases.dart';
import 'package:grimity/domain/usecase/users_usecase.dart';
import 'package:grimity/presentation/common/provider/auth_credential_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_provider.g.dart';

enum SignUpViewState { nickname, url }

/// 회원가입 상태를 관리하는 프로바이더
@riverpod
class SignUp extends _$SignUp {
  @override
  SignUpState build() {
    return SignUpState();
  }

  /// 닉네임 업데이트
  void updateNickname(String nickname) {
    state = state.copyWith(nickname: nickname, nicknameState: GrimityTextFieldState.normal);
  }

  /// 약관 동의 상태 업데이트
  void updateTermsAgreement(bool isAgreed) {
    state = state.copyWith(isTermsAgreed: isAgreed);
  }

  /// URL 업데이트
  void updateUrl(String url) {
    state = state.copyWith(url: url, urlState: GrimityTextFieldState.normal);
  }

  /// 닉네임 중복 확인
  Future<void> checkNicknameDuplicate() async {
    if (!ValidatorUtil.isValidNickname(state.nickname) || state.isNicknameChecking) return;

    state = state.copyWith(isNicknameChecking: true);

    // 닉네임 중복 확인
    final result = await nameCheckUseCase.execute(state.nickname);
    result.fold(
      onSuccess: (data) {
        state = state.copyWith(
          isNicknameChecking: false,
          signUpViewState: SignUpViewState.url,
          nicknameState: GrimityTextFieldState.normal,
        );
      },
      onFailure: (error) {
        state = state.copyWith(
          isNicknameChecking: false,
          nicknameState: GrimityTextFieldState.error,
          nicknameCheckMessage: '중복된 닉네임입니다',
        );
      },
    );
  }

  /// URL 유효성 검증
  Future<void> checkUrlValidity() async {
    if (!ValidatorUtil.isValidUrl(state.url) || state.isUrlChecking) return;

    state = state.copyWith(isUrlChecking: true);

    try {
      final bool isAvailable = ValidatorUtil.isValidUrl(state.url);

      if (!isAvailable) {
        state = state.copyWith(
          isUrlChecking: false,
          urlState: GrimityTextFieldState.error,
          urlCheckMessage: '숫자, 영문(소문자), 언더바(_)만 입력 가능합니다.',
        );
        return;
      }

      state = state.copyWith(isUrlChecking: false, urlState: GrimityTextFieldState.normal);
    } catch (e) {
      state = state.copyWith(
        isUrlChecking: false,
        urlState: GrimityTextFieldState.error,
        urlCheckMessage: 'URL 확인 중 오류가 발생했습니다.',
      );
    }
  }

  /// 회원가입 진행
  Future<Result<User>> signUp(WidgetRef ref) async {
    if (!isInformationValid()) {
      return Result.failure(Exception('회원가입 정보가 유효하지 않습니다.'));
    }

    final authCredential = ref.read(authCredentialProvider);
    if (authCredential.provider == null) {
      return Result.failure(Exception('OAuth 인증 정보가 없습니다.'));
    }

    final param = RegisterRequestParam(
      provider: authCredential.provider!.name,
      providerAccessToken: authCredential.providerAccessToken!,
      name: state.nickname,
      url: state.url,
    );

    return await completeRegisterUseCase.execute(param, this.ref);
  }

  /// 유효성 검사
  bool isInformationValid() {
    return ValidatorUtil.isValidNickname(state.nickname) && ValidatorUtil.isValidUrl(state.url) && state.isTermsAgreed;
  }
}

/// 회원가입 상태 클래스
class SignUpState {
  final SignUpViewState signUpViewState;
  final String nickname;
  final GrimityTextFieldState nicknameState;
  final bool isNicknameChecking;
  final String? nicknameCheckMessage;

  final String url;
  final GrimityTextFieldState urlState;
  final bool isUrlChecking;
  final String? urlCheckMessage;

  final bool isTermsAgreed;

  SignUpState({
    this.signUpViewState = SignUpViewState.nickname,
    this.nickname = '',
    this.nicknameState = GrimityTextFieldState.normal,
    this.isNicknameChecking = false,
    this.nicknameCheckMessage,
    this.url = '',
    this.urlState = GrimityTextFieldState.normal,
    this.isUrlChecking = false,
    this.urlCheckMessage,
    this.isTermsAgreed = false,
  });

  SignUpState copyWith({
    SignUpViewState? signUpViewState,
    String? nickname,
    GrimityTextFieldState? nicknameState,
    bool? isNicknameChecking,
    String? nicknameCheckMessage,
    String? url,
    GrimityTextFieldState? urlState,
    bool? isUrlChecking,
    String? urlCheckMessage,
    bool? isTermsAgreed,
  }) {
    return SignUpState(
      signUpViewState: signUpViewState ?? this.signUpViewState,
      nickname: nickname ?? this.nickname,
      nicknameState: nicknameState ?? this.nicknameState,
      isNicknameChecking: isNicknameChecking ?? this.isNicknameChecking,
      nicknameCheckMessage: nicknameCheckMessage ?? this.nicknameCheckMessage,
      url: url ?? this.url,
      urlState: urlState ?? this.urlState,
      isUrlChecking: isUrlChecking ?? this.isUrlChecking,
      urlCheckMessage: urlCheckMessage ?? this.urlCheckMessage,
      isTermsAgreed: isTermsAgreed ?? this.isTermsAgreed,
    );
  }
}
