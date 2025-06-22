import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_animation_button.dart';
import 'package:grimity/presentation/common/widget/grimity_post_card.dart';
import 'package:grimity/presentation/home/hook/use_infinite_scroll_hook.dart';
import 'package:grimity/presentation/storage/provider/storage_save_post_data_provider.dart';
import 'package:grimity/presentation/storage/view/storage_empty_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StorageSavePostView extends HookConsumerWidget {
  const StorageSavePostView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();
    final savePost = ref.watch(savePostDataProvider);

    return savePost.maybeWhen(
      data:
          (data) => data.posts.isEmpty ? StorageEmptyView(topPadding: 92) : _StorageSavePostListView(posts: data.posts),
      orElse: () => Skeletonizer(child: _StorageSavePostListView(posts: Post.emptyList)),
    );
  }
}

class _StorageSavePostListView extends HookConsumerWidget {
  const _StorageSavePostListView({required this.posts});

  final List<Post> posts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    useInfiniteScrollHook(
      ref: ref,
      scrollController: scrollController,
      loadFunction: () async => await ref.read(savePostDataProvider.notifier).loadMore(),
    );

    return ListView.separated(
      controller: scrollController,
      separatorBuilder: (context, index) {
        return Divider(color: AppColor.gray300, height: 1, thickness: 1);
      },
      itemBuilder: (context, index) {
        final post = posts[index];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: GrimityPostCard(post: post)),
              Gap(6),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: GrimityAnimationButton(
                  onTap:
                      () => ref
                          .read(savePostDataProvider.notifier)
                          .toggleSavePost(postId: post.id, save: post.isSave == true ? false : true),
                  child:
                      post.isSave == true
                          ? Assets.icons.storage.saveFill.svg(width: 20, height: 20)
                          : Assets.icons.storage.save.svg(width: 20, height: 20),
                ),
              ),
            ],
          ),
        );
      },
      itemCount: posts.length,
    );
  }
}
