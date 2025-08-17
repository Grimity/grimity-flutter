import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/drawer/main_app_drawer.dart';

class PostDetailView extends HookWidget {
  final Post post;
  final Widget postDetailAppBar;
  final Widget postContentView;

  PostDetailView({super.key, required this.post, required this.postDetailAppBar, required this.postContentView});

  final Widget grayGap = SliverToBoxAdapter(child: Container(color: AppColor.gray200, height: 8));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MainAppDrawer(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            postDetailAppBar,
            SliverToBoxAdapter(child: Gap(16)),
            SliverToBoxAdapter(child: postContentView),
            grayGap,
          ],
        ),
      ),
    );
  }
}
