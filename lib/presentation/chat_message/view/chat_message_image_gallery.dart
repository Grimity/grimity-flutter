import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/chat_message/provider/chat_message_provider.dart';
import 'package:grimity/presentation/common/model/image_item_source.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/photo_select/widget/photo_asset_thumbnail_widget.dart';

class ChatMessageImageGallery extends ConsumerWidget {
  const ChatMessageImageGallery({super.key, required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerFamily = chatMessageProviderProvider(chatId: chatId);
    final provider = ref.read(providerFamily.notifier);
    final data = ref.watch(providerFamily);
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
          final inputImage = data.value!.inputImages[index];
          final imageAsset = inputImage as AssetImageSource;

          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: PhotoAssetThumbnailWidget(asset: imageAsset.asset),
              ),

              // TODO: 이미지 선택 취소 버튼.
              Align(
                alignment: Alignment.topRight,
                child: GrimityGesture(
                  onTap: () => provider.removeInputImage(inputImage),
                  child: Padding(padding: EdgeInsets.all(2), child: Assets.icons.chatMessage.remove.svg()),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
