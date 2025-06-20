import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileCropImageView extends HookConsumerWidget {
  const ProfileCropImageView({super.key, required this.cropImage, required this.cropGuide, required this.cropButton});

  final Widget cropImage;
  final Widget cropGuide;
  final Widget cropButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Center(
          child: GestureDetector(
            onTap: () => context.pop(),
            child: Assets.icons.profileEdit.arrowLeft.svg(width: 24, height: 24),
          ),
        ),
      ),
      body: Column(children: [cropImage, Gap(16), cropGuide, Gap(150), cropButton, Gap(16)]),
    );
  }
}
