import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/drawer/main_app_drawer.dart';
import 'package:grimity/presentation/feed_detail/view/feed_content_view.dart';
import 'package:grimity/presentation/feed_detail/widget/feed_detail_app_bar.dart';
import 'package:grimity/presentation/feed_detail/widget/feed_util_bar.dart';

class FeedDetailView extends StatelessWidget {
  final Feed feed;

  const FeedDetailView({super.key, required this.feed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO : 되돌아오는 Route 구조 변경 필요
      endDrawer: MainAppDrawer(currentIndex: 0),
      body: SafeArea(
        child: Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                final ctx = feedContentKey.currentContext;
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
                  if (bottom <= screenHeight) {
                    // print('postDetailView의 끝이 화면 하단에 도달!');
                  }
                  // print('View가 화면 상단 기준에서 얼마나 떨어져있나 ? [$bottom] \t 화면 높이 $screenHeight');
                }
                return false; // false가 위로 전파
              },
              child: CustomScrollView(
                slivers: [
                  FeedDetailAppBar(),
                  SliverToBoxAdapter(child: Gap(16)),
                  SliverToBoxAdapter(child: FeedContentView(feed: feed)),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: FeedUtilBar(feed: feed)),
            ),
          ],
        ),
      ),
    );
  }
}
