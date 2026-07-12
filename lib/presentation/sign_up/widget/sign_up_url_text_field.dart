import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/enum/grimity.enum.dart';
import 'package:grimity/presentation/sign_up/provider/sign_up_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpUrlTextField extends HookConsumerWidget {
  const SignUpUrlTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();
    final focusNode = useFocusNode();
    final state = ref.watch(signUpProvider);
    final urlStatus = state.urlState;
    final errorMessage = state.urlCheckMessage;

    // 첫 Build 시 포커스 요청
    useEffect(() {
      focusNode.requestFocus();
      return null;
    }, []);

    return GdsInput(
      placeholder: '숫자, 영문(소문자), 언더바(_)',
      controller: textController,
      focusNode: focusNode,
      error: urlStatus == GrimityTextFieldState.error,
      success: urlStatus == GrimityTextFieldState.success,
      helperText: urlStatus == GrimityTextFieldState.error ? errorMessage : null,
      onChanged: ref.read(signUpProvider.notifier).updateUrl,
      onEditingComplete: ref.read(signUpProvider.notifier).checkUrlValidity,
    );
  }
}
