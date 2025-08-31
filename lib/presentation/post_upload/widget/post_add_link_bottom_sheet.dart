import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_text_field.dart';

class PostAddLinkBottomSheet extends HookWidget {
  const PostAddLinkBottomSheet({super.key, this.initialText, this.initialUrl, required this.onSubmit});

  final String? initialText;
  final String? initialUrl;
  final void Function(String text, String url) onSubmit;

  static void show(
    BuildContext context, {
    String? initialText,
    String? initialUrl,
    required final void Function(String text, String url) onSubmit,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      builder: (context) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;

        return AnimatedPadding(
          padding: EdgeInsets.only(bottom: bottomInset),
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: PostAddLinkBottomSheet(initialText: initialText, initialUrl: initialUrl, onSubmit: onSubmit),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController(text: initialText ?? '');
    final urlController = useTextEditingController(text: initialUrl ?? '');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(24),
          Row(
            children: [
              Text('링크 추가', style: AppTypeface.subTitle3),
              const Spacer(),
              GestureDetector(onTap: () => context.pop(), child: Assets.icons.common.close.svg(width: 24, height: 24)),
            ],
          ),
          Gap(24),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Text', style: AppTypeface.caption1.copyWith(color: AppColor.gray800)),
                Gap(10),
                GrimityTextField.small(controller: textController, maxLines: 1, hintText: 'grimity'),
                Gap(16),
                Text('Link', style: AppTypeface.caption1.copyWith(color: AppColor.gray800)),
                Gap(10),
                GrimityTextField.small(controller: urlController, maxLines: 1, hintText: 'www.grimity.com'),
              ],
            ),
          ),
          Gap(24),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              final text = textController.value.text.trim();
              final url = _normalizeUrl(urlController.value.text);
              if (url.isEmpty) return;
              onSubmit(text, url);
              context.pop();
            },
            child: Container(
              height: 42,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColor.primary4),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                child: Center(child: Text('추가', style: AppTypeface.label2.copyWith(color: AppColor.gray00))),
              ),
            ),
          ),
          Gap(24),
        ],
      ),
    );
  }

  String _normalizeUrl(String u) {
    final s = u.trim();
    if (s.isEmpty) return s;
    final hasScheme = RegExp(r'^[a-zA-Z][a-zA-Z0-9+\-.]*://').hasMatch(s);
    return hasScheme ? s : 'https://$s';
  }
}
