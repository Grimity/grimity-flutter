import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_infinite_scroll_pagination/flutter_infinite_scroll_pagination.dart';
import 'package:grimity/presentation/common/widget/grimity_loading_indicator.dart';

// 공통 무한 스크롤 페이지네이션 위젯.
// 공통된 loading indicator를 사용
class GrimityInfiniteScrollPagination extends StatelessWidget {
  const GrimityInfiniteScrollPagination({
    super.key,
    required this.child,
    this.isEnabled = true,
    required this.onLoadMore,
    this.reverse = false,
  });

  final Widget child;
  final bool isEnabled;
  final AsyncCallback onLoadMore;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return InfiniteScrollPagination(
      isEnabled: isEnabled,
      loadingIndicator: GrimityLoadingIndicator.loadMore(),
      onLoadMore: onLoadMore,
      reverse: reverse,
      child: child,
    );
  }
}
