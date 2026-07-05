import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/post_upload/widget/post_upload_content_text_field.dart';
import 'package:grimity/presentation/post_upload/widget/post_upload_title_text_field.dart';
import 'package:grimity/presentation/post_upload/widget/post_upload_toolbar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostUploadBodyView extends HookConsumerWidget {
  const PostUploadBodyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: GdsSpacing.spacing24,
                horizontal: GdsSpacing.spacing20,
              ),
              child: Column(
                children: [
                  PostUploadTitleTextField(),
                  PostUploadContentTextField(scrollController: scrollController),
                ],
              ),
            ),
          ),
        ),
        PostUploadToolbar(),
      ],
    );
  }
}
