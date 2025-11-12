import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/comment/enum/comment_type.dart';
import 'package:grimity/presentation/comment/provider/comment_input_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/drawer/main_app_drawer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeedDetailView extends HookConsumerWidget {
  final Feed feed;
  final Widget feedDetailAppBar;
  final Widget feedContentView;
  final Widget feedCommentsView;
  final Widget feedAuthorProfileView;
  final Widget feedRecommendFeedView;
  final Widget feedCommentInputBar;
  final Widget feedUtilBar;

  FeedDetailView({
    super.key,
    required this.feed,
    required this.feedDetailAppBar,
    required this.feedContentView,
    required this.feedCommentsView,
    required this.feedAuthorProfileView,
    required this.feedRecommendFeedView,
    required this.feedCommentInputBar,
    required this.feedUtilBar,
  });

  final Widget grayGap = SliverToBoxAdapter(child: Container(color: AppColor.gray200, height: 8));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentInputNotifier = ref.watch(commentInputProvider(CommentType.feed).notifier);
    final showCommentInputBar = useState(false);
    final scrollController = useScrollController();

    // FeedContentView 위치 추적용 context 저장
    final feedContentContextRef = useRef<BuildContext?>(null);

    void updateBarVisibility() {
      final ctx = feedContentContextRef.value;
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
        final ctx = feedContentContextRef.value;
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
        final focusNode = commentInputNotifier.focusNode;

        // 이미 포커스된 경우 해제한 뒤, 프레임 종료 후 다시 포커스를 요청.
        if (focusNode?.hasFocus ?? false) {
          focusNode?.unfocus();
          await WidgetsBinding.instance.endOfFrame;
        }

        focusNode?.requestFocus();
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
                    feedDetailAppBar,
                    SliverToBoxAdapter(child: Gap(16)),
                    SliverToBoxAdapter(
                      child: Builder(
                        builder: (context) {
                          // 위치 추적용 context 저장
                          feedContentContextRef.value = context;
                          return feedContentView;
                        },
                      ),
                    ),
                    grayGap,
                    SliverToBoxAdapter(child: feedCommentsView),
                    grayGap,
                    SliverToBoxAdapter(child: feedAuthorProfileView),
                    grayGap,
                    SliverToBoxAdapter(child: feedRecommendFeedView),
                    SliverToBoxAdapter(child: Gap(52)),
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
                          ? feedCommentInputBar
                          : Container(
                            color: AppColor.gray00,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: feedUtilBar,
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
