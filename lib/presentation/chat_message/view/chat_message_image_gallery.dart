import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/chat_message/provider/chat_message_provider.dart';
import 'package:grimity/presentation/common/model/image_item_source.dart';
import 'package:grimity/presentation/photo_select/widget/photo_asset_thumbnail_widget.dart';

class ChatMessageImageGallery extends ConsumerWidget {
  const ChatMessageImageGallery({super.key, required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerFamily = chatMessageProviderProvider(chatId: chatId);
    final provider = ref.read(providerFamily.notifier);
    final colors = context.gdsColors;
    final data = ref.watch(providerFamily);
    final imageAssets = data.value!.inputImages.map((e) => (e as AssetImageSource).asset).toList();

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: GdsSpacing.spacing8,
        horizontal: GdsSpacing.spacing16,
      ),
      color: colors.surface.black.withAlpha((GdsOpacity.opacity80 * 255).toInt()),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.isMobile ? 5 : 8,
          mainAxisSpacing: GdsSpacing.spacing8,
          crossAxisSpacing: GdsSpacing.spacing8,
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: imageAssets.length,
        itemBuilder: (context, index) {
          final inputImage = data.value!.inputImages[index];
          final imageAsset = inputImage as AssetImageSource;

          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(GdsRadius.sm),
                child: PhotoAssetThumbnailWidget(asset: imageAsset.asset),
              ),
              Align(
                alignment: Alignment.topRight,
                child: GdsGesture(
                  onTap: () => provider.removeInputImage(inputImage),
                  child: Padding(
                    padding: EdgeInsets.all(GdsSpacing.spacing2),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(GdsRadius.xs),
                      ),
                      width: GdsSpacing.spacing16,
                      height: GdsSpacing.spacing16,
                      child: GdsIcon.xMark.build(color: GdsColors.white),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
