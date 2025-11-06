import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/comment/enum/comment_type.dart';
import 'package:grimity/presentation/comment/provider/comment_input_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_animation_button.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CommentInputBar extends HookConsumerWidget {
  const CommentInputBar({super.key, required this.id, required this.commentType});

  final String id;
  final CommentType commentType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final state = ref.watch(commentInputProvider(commentType));
    final notifier = ref.read(commentInputProvider(commentType).notifier);
    final isNotEmpty = state.content.trim().isNotEmpty;

    useEffect(() {
      if (controller.text != state.content) {
        controller.text = state.content;
      }

      return null;
    }, [state.content]);

    return Column(
      children: [
        if (state.replyUserName != null)
          Container(
            decoration: BoxDecoration(color: AppColor.gray200),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '@${state.replyUserName}',
                          style: AppTypeface.caption2.copyWith(color: AppColor.gray700),
                        ),
                        TextSpan(text: '님에게 답글', style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
                      ],
                    ),
                  ),
                  GrimityAnimationButton(
                    onTap: () => notifier.clearReplyState(),
                    child: Assets.icons.common.close.svg(width: 14.w, height: 14.w),
                  ),
                ],
              ),
            ),
          ),
        Container(
          constraints: BoxConstraints(minHeight: 52),
          decoration: BoxDecoration(
            color: AppColor.gray00,
            border: Border(top: BorderSide(color: AppColor.gray300, width: 1)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    maxLines: 5,
                    minLines: 1,
                    maxLength: 1000,
                    keyboardType: TextInputType.multiline,
                    style: AppTypeface.label2.copyWith(color: AppColor.gray800),
                    decoration: InputDecoration(
                      hintText: "이 그림, 어떻게 느껴졌나요?",
                      border: InputBorder.none,
                      hintStyle: AppTypeface.label2.copyWith(color: AppColor.gray500),
                      counterText: '',
                    ),
                    scrollPhysics: BouncingScrollPhysics(),
                    onChanged: (content) => notifier.updateContent(content),
                  ),
                ),
                GrimityGesture(
                  onTap:
                      !isNotEmpty || state.uploading
                          ? null
                          : () {
                            notifier.createComment(id: id);
                            FocusScope.of(context).unfocus();
                          },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                      color: isNotEmpty ? AppColor.primary4 : AppColor.gray300,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: isNotEmpty ? AppColor.primary4 : AppColor.gray300, width: 1),
                    ),
                    child: Text(
                      '등록',
                      style: AppTypeface.caption3.copyWith(color: isNotEmpty ? AppColor.gray00 : AppColor.gray500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
