import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/sign_up/views/sign_up_view.dart';
import 'package:grimity/presentation/sign_up/views/sign_up_url_view.dart';
import 'package:grimity/presentation/sign_up/widgets/sign_up_terms_agreement.dart';
import 'package:pervice/pervice.dart';

/// 회원가입에 사용할 닉네임을 입력하고 약관 동의를 받는 화면.
class SignUpNicknameView extends SignUpView {
  /// 사용자가 입력한 닉네임.
  String nickname = '';

  /// 닉네임 검사 실패 시 표시할 오류 메시지.
  String? errorMessage;

  /// 서비스 이용약관과 개인정보처리방침에 동의했는지 여부.
  bool isAgree = false;

  @override
  String get label => '다음';

  // 관련 약관을 동의함과 동시에 입력된 닉네임의 길이가 2~12인 경우.
  @override
  bool get canSubmit {
    return nickname.length >= 2 && nickname.length <= 12 && isAgree;
  }

  @override
  Future<SignUpView?> onSubmit(BuildContext context) async {
    try {
      await PostUsersNameCheck(request: .new(name: nickname)).request();

      // 뒤로 가기를 고려하여 성공 시 에러 메시지 초기화.
      errorMessage = null;

      return SignUpUrlView(nickname);
    } on DioException catch (error) {
      errorMessage = switch (error.response?.statusCode) {
        // 유효성 검사에서 실패했을 경우.
        400 => '올바른 닉네임 형태를 입력해주세요',

        // 다른 사용자가 이미 사용하고 있을 경우.
        409 => '중복된 닉네임입니다',

        _ => '닉네임 확인 중 오류가 발생했어요',
      };
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: .start,
        spacing: 40,
        children: [
          Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            spacing: 12,
            children: [
              // 제목 표시
              GdsText(
                '활동명을 정해주세요',
                color: .textGrayBold,
                style: context.whenDevice(
                  mobile: .title1,
                  tablet: .title2,
                ),
              ),

              // 설명 표시
              GdsText(
                '작품과 함께 그리미티에서 기억될 이름이에요',
                color: .textGrayBold,
                style: .body1R,
              ),
            ],
          ),

          Column(
            mainAxisSize: .min,
            spacing: 12,
            children: [
              // 닉네임 입력 필드 표시
              GdsInput.title(
                helperText: errorMessage,
                helperStatus: .error,
                field: GdsTextField.normal(
                  size: .md,
                  status: errorMessage != null ? .error : .enabled,
                  placeholder: '닉네임을 입력해주세요',
                  maxLength: 12,
                  onChanged: (value) {
                    context.setState(() => nickname = value);
                  },
                ),
              ),

              // 관련 약관 동의 필드 표시
              SignUpTermsAgreement(
                value: isAgree,
                onChanged: (value) {
                  context.setState(() => isAgree = value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
