import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/chat_message/provider/chat_message_provider.dart';
import 'package:grimity/presentation/common/model/image_item_source.dart';
import 'package:grimity/presentation/photo_select/widget/photo_asset_thumbnail_widget.dart';

class ChatMessageImageGallery extends ConsumerWidget {
  const ChatMessageImageGallery({required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(chatMessageProviderProvider(chatId: chatId));
    final imageAssets = data.value!.inputImages.map((e) => (e as AssetImageSource).asset).toList();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.black.withAlpha(200),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        shrinkWrap: true,
        itemCount: imageAssets.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: PhotoAssetThumbnailWidget(asset: imageAssets[index]),
              ),

              // TODO: 이미지 선택 취소 버튼.
              Align(
                alignment: Alignment.topRight,
                child: SizedBox(),
              ),
            ],
          );
        },
      ),
    );
  }
}
