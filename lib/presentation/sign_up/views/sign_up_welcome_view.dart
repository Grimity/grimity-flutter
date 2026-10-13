import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/sign_up/views/sign_up_view.dart';

/// 회원가입 완료를 안내하고 환영하는 화면.
class SignUpWelcomeView extends SignUpView {
  @override
  String get label => '그리미티 시작하기';

  @override
  bool get canSubmit => true;

  @override
  EdgeInsets? get scrollPadding => .all(0);

  @override
  Future<SignUpView?> onSubmit(BuildContext context) async {
    // 홈 페이지로 이동.
    if (context.mounted) {
      context.pop();
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisSize: .min,
          children: [
            // 일러스트 표시
            GdsIcon.uploadSuccess.build(size: 120),
            24.verticalGap,

            // 제목 표시
            GdsText(
              '가입을 축하드려요!',
              color: .textGrayBold,
              style: context.whenDevice(
                mobile: .title2,
                tablet: .title1,
              ),
            ),
            12.verticalGap,

            // 부제목 표시
            GdsText(
              '마음껏 그림을 공유하고\n자유롭게 이야기를 나눠보세요',
              color: .textGrayBold,
              style: .body1R,
              textAlign: .center,
            ),
          ],
        ),
      ),
    );
  }
}
