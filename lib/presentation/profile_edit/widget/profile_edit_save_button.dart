import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/common/widget/button/grimity_button.dart';
import 'package:grimity/presentation/profile/provider/profile_data_provider.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileEditSaveButton extends ConsumerWidget {
  const ProfileEditSaveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: 4,
          left: 16,
          right: 16,
          bottom: 24,
        ),
        child: GrimityButton.large(
          text: '변경 내용 저장',
          onTap: () async {
            final router = ref.read(routerProvider);

            await ref.read(profileEditProvider.notifier).updateUser();
            if (context.mounted && ref.read(profileEditProvider).isSaved == true) {
              final newUrl = ref.read(profileEditProvider).url;
              // ProfileEdit 페이지 Pop
              if (router.canPop()) {
                router.pop();
              }

              // 기존 Profile 페이지에서 사용하는 데이터 무효화
              ref.invalidate(profileDataProvider);

              // 변경된 URL 기준으로 프로필 페이지 pushReplacement
              WidgetsBinding.instance.addPostFrameCallback(
                (timeStamp) => router.pushReplacement(ProfileRoute.makePath(newUrl)),
              );
            }
          },
        ),
      ),
    );
  }
}
