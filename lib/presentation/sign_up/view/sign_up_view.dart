import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grimity/presentation/sign_up/provider/sign_up_provider.dart';
import 'package:grimity/presentation/sign_up/view/sign_up_nickname_view.dart';
import 'package:grimity/presentation/sign_up/view/sign_up_url_view.dart';
import 'package:grimity/presentation/sign_up/widget/sign_up_app_bar.dart';

class SignUpView extends ConsumerWidget {
  const SignUpView({
    super.key,
    required this.nicknameTextField,
    required this.urlTextField,
    required this.termAgreeWidget,
    required this.checkNicknameButton,
    required this.registerButton,
  });

  final Widget nicknameTextField;
  final Widget urlTextField;
  final Widget termAgreeWidget;
  final Widget checkNicknameButton;
  final Widget registerButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpRef = ref.watch(signUpProvider);

    return Scaffold(
      appBar: SignUpAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(40),
            Expanded(
              child: PageTransitionSwitcher(
                duration: const Duration(milliseconds: 200),
                reverse: signUpRef.signUpViewState == SignUpViewState.nickname,
                transitionBuilder: (
                  Widget child,
                  Animation<double> primaryAnimation,
                  Animation<double> secondaryAnimation,
                ) {
                  return SharedAxisTransition(
                    animation: primaryAnimation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.vertical,
                    fillColor: Colors.transparent,
                    child: child,
                  );
                },
                child:
                    signUpRef.signUpViewState == SignUpViewState.nickname
                        ? SignUpNicknameView(
                          key: const ValueKey('nickname'),
                          nicknameTextField: nicknameTextField,
                          termAgreeWidget: termAgreeWidget,
                          checkNicknameButton: checkNicknameButton,
                        )
                        : SignUpUrlView(
                          key: const ValueKey('url'),
                          nickname: signUpRef.nickname,
                          urlTextField: urlTextField,
                          registerButton: registerButton,
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
