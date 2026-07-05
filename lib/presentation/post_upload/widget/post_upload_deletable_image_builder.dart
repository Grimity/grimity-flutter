import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/common/widget/grimity_cached_network_image.dart';
import 'package:grimity/presentation/post_upload/provider/post_upload_page_argument_provider.dart';
import 'package:grimity/presentation/post_upload/provider/post_upload_provider.dart';

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
            )
            : Image.file(File(imageUrl), fit: BoxFit.cover);

    return Consumer(
      builder: (context, ref, child) {
        final notifier = ref.read(postUploadProvider.notifier);
        final quillController = ref.read(postUploadQuillControllerArgumentProvider);

        return GdsGesture(
          onTap: () => notifier.deleteImage(quillController, imageUrl),
          child: child,
        );
      },
      child: child,
    );
  }
}
