import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/presentation/common/widget/grimity_text_field.dart';
import 'package:grimity/presentation/sign_up/provider/sign_up_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpUrlTextField extends HookConsumerWidget {
  const SignUpUrlTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();
    final focusNode = useFocusNode();

    // 첫 Build 시 포커스 요청
    useEffect(() {
      focusNode.requestFocus();
      return null;
    }, []);

    return GrimityTextField.normal(
      controller: textController,
      state: ref.watch(signUpProvider).urlState,
      autoFocus: true,
      focusNode: focusNode,
      hintText: '숫자, 영문(소문자), 언더바(_)',
      errorText: ref.watch(signUpProvider).urlCheckMessage,
      onChanged: (value) {
        ref.read(signUpProvider.notifier).updateUrl(value);
      },
      onSubmitted: (value) {
        ref.read(signUpProvider.notifier).updateUrl(value);
      },
    );
  }
}
