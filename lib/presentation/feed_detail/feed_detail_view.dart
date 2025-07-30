import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/drawer/main_app_drawer.dart';

class FeedDetailView extends HookWidget {
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
  Widget build(BuildContext context) {
    final showCommentInputBar = useState(false);

    // FeedContentView 위치 추적용 context 저장
    final feedContentContextRef = useRef<BuildContext?>(null);

    return Scaffold(
      endDrawer: MainAppDrawer(),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  final ctx = feedContentContextRef.value;

                  if (ctx != null) {
                    // feedDetailView의 RenderBox를 얻음 (위젯의 실제 위치, 크기 정보를 얻기 위해)
                    final box = ctx.findRenderObject() as RenderBox;

                    // postDetailView의 "상단"이 화면 기준에서 얼마나 떨어져 있는지(절대좌표, 단위: px)
                    final pos = box.localToGlobal(Offset.zero);

                    // postDetailView의 "높이" (px)
                    final height = box.size.height;

                    // 현재 기기의 "전체 화면 높이" (상태바, 네비게이션바 제외된 SafeArea 높이)
                    final screenHeight = MediaQuery.of(ctx).size.height;

                    // postDetailView의 "하단"이 화면 상단 기준에서 얼마나 떨어져 있는지(절대좌표)
                    final bottom = pos.dy + height;

                    // postDetailView가 화면 하단에 도달했을 때
                    showCommentInputBar.value = bottom <= screenHeight;
                  }
                  return false; // false가 위로 전파
                },
                child: CustomScrollView(
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
