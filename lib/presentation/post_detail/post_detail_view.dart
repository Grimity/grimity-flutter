import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/comment/enum/comment_type.dart';
import 'package:grimity/presentation/comment/provider/comment_input_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/drawer/main_app_drawer.dart';
import 'package:grimity/presentation/post_detail/view/post_latest_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostDetailView extends HookConsumerWidget {
  final Post post;
  final Widget postDetailAppBar;
  final Widget postContentView;
  final Widget postCommentsView;
  final Widget postCommentInputBar;
  final Widget postUtilBar;

  PostDetailView({
    super.key,
    required this.post,
    required this.postDetailAppBar,
    required this.postContentView,
    required this.postCommentsView,
    required this.postCommentInputBar,
    required this.postUtilBar,
  });

  final Widget grayGap = SliverToBoxAdapter(child: Container(color: AppColor.gray200, height: 8));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentInputNotifier = ref.watch(commentInputProvider(CommentType.post).notifier);
    final showCommentInputBar = useState(false);
    final scrollController = useScrollController();

    // PostContentView 위치 추적용 context 저장
    final postContentContextRef = useRef<BuildContext?>(null);

    void updateBarVisibility() {
      final ctx = postContentContextRef.value;
      if (ctx == null) return;

      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) return;

      final pos = box.localToGlobal(Offset.zero);
      final height = box.size.height;

      final media = MediaQuery.of(ctx);
      final screenHeight = media.size.height;

      final bottom = pos.dy + height;

      // 본문 하단이 화면 하단에 닿거나 넘으면 댓글 입력 바 노출
      showCommentInputBar.value = bottom <= screenHeight;
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        updateBarVisibility();
      });
      return null;
    }, const []);

    useEffect(() {
      commentInputNotifier.requestFocus = () async {
        final ctx = postContentContextRef.value;
        if (ctx == null) return;

        final box = ctx.findRenderObject() as RenderBox?;
        if (box == null || !box.attached) return;

        // 라인 높이까지 고려해서.
        final contentHeight = box.size.height + 16;

        await scrollController.animateTo(
          contentHeight,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );

        assert(commentInputNotifier.focusNode != null);
        commentInputNotifier.focusNode?.requestFocus();
      };

      return null;
    }, [commentInputNotifier]);

    return Scaffold(
      endDrawer: MainAppDrawer(),
      body: SafeArea(
        child: GrimityGesture(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  updateBarVisibility();
                  return false;
                },
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    postDetailAppBar,
                    SliverToBoxAdapter(child: Gap(16)),
                    SliverToBoxAdapter(
                      child: Builder(
                        builder: (context) {
                          // 위치 추적용 context 저장
                          postContentContextRef.value = context;
                          return postContentView;
                        },
                      ),
                    ),
                    grayGap,
                    SliverToBoxAdapter(child: postCommentsView),
                    grayGap,
                    SliverToBoxAdapter(child: PostLatestView()),
                    SliverToBoxAdapter(child: Gap(22)),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child:
                      showCommentInputBar.value
                          ? postCommentInputBar
                          : Container(
                            color: AppColor.gray00,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: postUtilBar,
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
