import 'package:flutter/material.dart';
import 'package:grimity/presentation/sign_up/view/sign_up_view.dart';
import 'package:grimity/presentation/sign_up/widget/sign_up_check_nick_button.dart';
import 'package:grimity/presentation/sign_up/widget/sign_up_check_url_button.dart';
import 'package:grimity/presentation/sign_up/widget/sign_up_nickname_text_field.dart';
import 'package:grimity/presentation/sign_up/widget/sign_up_term_agree_widget.dart';
import 'package:grimity/presentation/sign_up/widget/sign_up_url_text_field.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SignUpView(
      nicknameTextField: SignUpNicknameTextField(),
      urlTextField: SignUpUrlTextField(),
      termAgreeWidget: SignUpTermAgreeWidget(),
      checkNicknameButton: SignUpCheckNickButton(),
      registerButton: SignUpCheckUrlButton(),
    );
  }
}
