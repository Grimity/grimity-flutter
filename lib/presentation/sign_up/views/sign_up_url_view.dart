import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/presentation/sign_up/pages/sign_up_page.dart';
import 'package:grimity/presentation/sign_up/views/sign_up_view.dart';
import 'package:grimity/presentation/sign_up/views/sign_up_welcome_view.dart';
import 'package:pervice/pervice.dart';

/// 프로필 URL을 입력하고 회원가입을 완료하는 화면.
class SignUpUrlView extends SignUpView {
  new(this.nickname);

  /// 사용자가 입력한 닉네임.
  final String nickname;

  /// 사용자가 입력한 프로필 URL.
  String url = '';

  /// 회원가입 실패 시 표시할 오류 메시지.
  String? errorMessage;

  @override
  String get label => '완료';

  // URL의 길이가 2 이상인 경우.
  @override
  bool get canSubmit => url.length >= 2;

  @override
  Future<SignUpView?> onSubmit(BuildContext context) async {
    final widget = context.widget as SignUpPage;

    try {
      await AppUser.signUp(
        widget.provider,
        widget.accessToken,
        nickname,
        url,
      );

      return SignUpWelcomeView();
    } on DioException catch (error) {
      errorMessage = switch (error.response?.statusCode) {
        // 유효성 검사에 실패했을 경우.
        400 => '올바른 프로필 URL 형태를 입력해주세요',

        // 다른 사용자가 이미 사용하고 있을 경우.
        409 => '중복된 프로필 URL입니다',

        // 알 수 없는 오류인 경우.
        _ => '프로필 URL 확인 중 오류가 발생했어요',
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
                '프로필 URL을 정해주세요',
                color: .textGrayBold,
                style: context.whenDevice(
                  mobile: .title1,
                  tablet: .title2,
                ),
              ),

              // 설명 표시
              GdsText(
                '단 하나뿐인 프로필 주소로 사용돼요',
                color: .textGrayBold,
                style: .body1R,
              ),
            ],
          ),

          Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            spacing: 12,
            children: [
              /// 플레이스 홀더 표시
              GdsText(
                'www.grimity.com/',
                color: .textGrayBold,
                style: .title2,
              ),

              // URL 입력 필드 표시
              GdsInput.title(
                helperText: errorMessage,
                helperStatus: .error,
                field: GdsTextField.normal(
                  size: .md,
                  status: errorMessage != null ? .error : .enabled,
                  placeholder: '숫자, 영문(소문자), 언더바(_)',
                  onChanged: (value) {
                    context.setState(() => url = value);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
