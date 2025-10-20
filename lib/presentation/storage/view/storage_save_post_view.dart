import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_animation_button.dart';
import 'package:grimity/presentation/common/widget/system/pagination/grimity_pagination_widget.dart';
import 'package:grimity/presentation/common/widget/grimity_post_card.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/storage/enum/storage_enum_item.dart';
import 'package:grimity/presentation/storage/provider/storage_save_post_data_provider.dart';
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
          (data) =>
              data.posts.isEmpty
                  ? GrimityStateView.resultNull(subTitle: StorageTabType.savePost.emptyMessage)
                  : _StorageSavePostListView(posts: data.posts, totalCount: data.totalCount ?? 0),
      orElse: () => Skeletonizer(child: _StorageSavePostListView(posts: Post.emptyList)),
    );
  }
}

class _StorageSavePostListView extends ConsumerWidget {
  const _StorageSavePostListView({required this.posts, this.totalCount = 0});

  final List<Post> posts;
  final int totalCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      itemCount: posts.length + 1,
      separatorBuilder: (context, index) {
        return Divider(color: AppColor.gray300, height: 1, thickness: 1);
      },
      itemBuilder: (context, index) {
        if (index < posts.length) {
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
                            .toggleSave(postId: post.id, save: post.isSave == true ? false : true),
                    child:
                        post.isSave == true
                            ? Assets.icons.common.saveFill.svg(width: 20, height: 20)
                            : Assets.icons.common.save.svg(width: 20, height: 20),
                  ),
                ),
              ],
            ),
          );
        }

        return GrimityPaginationWidget(
          currentPage: ref.read(savePostDataProvider.notifier).currentPage,
          size: ref.read(savePostDataProvider.notifier).size,
          totalCount: totalCount,
          onPageSelected: (page) => ref.read(savePostDataProvider.notifier).goToPage(page),
        );
      },
    );
  }
}
