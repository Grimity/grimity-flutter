import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/common/widget/grimity_cached_network_image.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/common/widget/system/check/grimity_check_box.dart';
import 'package:grimity/presentation/post_upload/provider/post_upload_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DeletableImageBuilder extends EmbedBuilder {
  DeletableImageBuilder();

  @override
  String get key => BlockEmbed.imageType;

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final node = embedContext.node;
    final widthAttr = node.style.attributes['width']?.value;
    final heightAttr = node.style.attributes['height']?.value;
    final double? width = widthAttr != null ? double.tryParse(widthAttr.toString()) : null;
    final double? height = heightAttr != null ? double.tryParse(heightAttr.toString()) : null;
    final imageUrl = embedContext.node.value.data as String;

    final child =
        imageUrl.indexOf("http") == 0
            ? GrimityCachedNetworkImage.cover(
              imageUrl: imageUrl,
              width: width,
              height: height,
              placeholder: (context, url) => Skeletonizer(child: SizedBox(width: width, height: height)),
              errorWidget: (context, url, error) => Skeletonizer(child: SizedBox(width: width, height: height)),
            )
            : Image.file(File(imageUrl), fit: BoxFit.cover);

    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(postUploadProvider);
        final notifier = ref.read(postUploadProvider.notifier);
        final imageEdit = state.imageEdit;
        final selected = state.selectedImageUrls.contains(imageUrl);

        if (!imageEdit) {
          return GrimityGesture(onTap: () => notifier.updateImageEdit(true), child: child);
        }

        return GrimityGesture(
          onTap: () => notifier.toggleSelectedImageUrl(imageUrl),
          child: Stack(
            children: [
              child!,
              Positioned.fill(child: Container(color: Colors.black.withValues(alpha: 0.5))),
              Positioned(
                right: 16,
                top: 16,
                child: GrimityCheckBox(value: selected, onChanged: (_) => notifier.toggleSelectedImageUrl(imageUrl)),
              ),
            ],
          ),
        );
      },
      child: child,
    );
  }
}
