import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/sign_up/provider/sign_up_provider.dart';
import 'package:grimity/presentation/sign_up/view/sign_up_nickname_view.dart';
import 'package:grimity/presentation/sign_up/view/sign_up_url_view.dart';
import 'package:grimity/presentation/sign_up/view/sign_up_welcome_view.dart';
import 'package:grimity/presentation/sign_up/widget/sign_up_app_bar.dart';
import 'package:grimity/presentation/sign_up/widget/sign_up_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpView extends HookConsumerWidget {
  const SignUpView({
    super.key,
    required this.nicknameTextField,
    required this.urlTextField,
    required this.termAgreeWidget,
  });

  final Widget nicknameTextField;
  final Widget urlTextField;
  final Widget termAgreeWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final signUp = ref.watch(signUpProvider.notifier);
    final state = ref.watch(signUpProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pageIndex = switch (state.signUpViewState) {
        SignUpViewState.nickname => 0,
        SignUpViewState.url => 1,
        SignUpViewState.welcome => 2,
      };

      if (pageController.page?.toInt() != pageIndex) {
        pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 300), curve: Curves.ease);
      }
    });

    return GdsScaffold(
      appBar: SignUpAppBar(),
      body: PopScope(
        canPop: state.signUpViewState == SignUpViewState.nickname,
        onPopInvoked: (didPop) {
          switch (state.signUpViewState) {
            case SignUpViewState.nickname:
              return context.pop();
            case SignUpViewState.url:
              signUp.setSignUpState(SignUpViewState.nickname);
            case SignUpViewState.welcome:
              return HomeRoute().go(context);
          }
        },
        child: Column(
          children: [
            Expanded(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: pageController,
                children: [
                  SignUpNicknameView(
                    key: const ValueKey('nickname'),
                    nicknameTextField: nicknameTextField,
                    termAgreeWidget: termAgreeWidget,
                  ),
                  SignUpUrlView(
                    key: const ValueKey('url'),
                    nickname: state.nickname,
                    urlTextField: urlTextField,
                  ),
                  SignUpWelcomeView(
                    key: const ValueKey('welcome'),
                  ),
                ],
              ),
            ),
            SignUpButton(),
          ],
        ),
      ),
    );
  }
}
