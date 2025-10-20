import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/chat_message/provider/chat_message_provider.dart';
import 'package:grimity/presentation/common/enum/upload_image_type.dart';
import 'package:grimity/presentation/common/model/image_item_source.dart';
import 'package:grimity/presentation/common/widget/button/grimity_button.dart';
import 'package:grimity/presentation/common/widget/grimity_text_field.dart';

class ChatMessageField extends ConsumerWidget {
  const ChatMessageField({
    super.key,
    required this.chatId,
  });

  final String chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerFamily = chatMessageProviderProvider(chatId: chatId);
    final provider = ref.read(providerFamily.notifier);
    final data = ref.watch(providerFamily);

    return Container(
      color: AppColor.gray100,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        spacing: 12,
        children: [
          Expanded(child: _TextField(chatId: chatId)),
          GrimityButton.round(
            text: "전송",
            onTap: provider.submit,
            status: !data.isLoading && data.value!.canSubmit
              ? ButtonStatus.on
              : ButtonStatus.off,
          ),
        ],
      ),
    );
  }
}

class _TextField extends ConsumerStatefulWidget {
  const _TextField({required this.chatId});

  final String chatId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TextFieldState();

}

class _TextFieldState extends ConsumerState<_TextField> {
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // View Model 측에서 텍스트 필드 내용을 수정할 수 있도록 관련 컨트롤러를 전달.
    final provider = ref.read(chatMessageProviderProvider(chatId: widget.chatId).notifier);
    provider.inputMessageController = _textEditingController;
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.read(chatMessageProviderProvider(chatId: widget.chatId).notifier);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.gray300),
        borderRadius: BorderRadius.circular(8),
        color: AppColor.gray00,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지 추가 액션 버튼 표시.
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              final List<ImageSourceItem>? pickedImages
                  = await PhotoSelectRoute(type: UploadImageType.chat).push(context);

              // 사용자가 메세지에 함께 보낼 이미지를 선택한 경우.
              if (pickedImages != null && pickedImages.isNotEmpty) {
                provider.addInputImages(pickedImages);
              }
            },
            child: Padding(
              padding: EdgeInsets.all(16).copyWith(right: 8),
              child: SvgPicture.asset(
                Assets.icons.profileEdit.camera.path,
                color: AppColor.gray700,
                width: 20,
              ),
            ),
          ),

          // 메세지 입력 필드 표시.
          Expanded(
            child: GrimityTextField.borderless(
              hintText: "메세지 내용을 입력해주세요",
              onChanged: provider.setInputMessage,
              onSubmitted: provider.setInputMessage,
              controller: _textEditingController,
            ),
          ),
        ],
      ),
    );
  }
}