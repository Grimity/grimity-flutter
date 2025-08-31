import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:grimity/presentation/post_upload/widget/post_upload_content_text_field.dart';
import 'package:grimity/presentation/post_upload/widget/post_upload_title_text_field.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostUploadBodyView extends HookConsumerWidget {
  const PostUploadBodyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: PostUploadTitleTextField()),
          Gap(16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: PostUploadContentTextField(scrollController: scrollController),
          ),
        ],
      ),
    );
  }
}
