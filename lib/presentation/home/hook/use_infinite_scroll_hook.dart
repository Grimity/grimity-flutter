import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _loadingStateProvider = StateProvider<bool>((ref) => false);

void useInfiniteScrollHook({
  required WidgetRef ref,
  required ScrollController scrollController,
  required Future<void> Function() loadFunction,
}) {
  final context = useContext();

  // 페이지가 마운트되고 나서 로딩 상태를 false로 초기화
  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(_loadingStateProvider.notifier).state = false;
    });

    // 스크롤 위치가 화면의 20% 위치에 도달하면 데이터를 로드하는 함수
    Future<void> checkScrollPosition() async {
      if (ref.read(_loadingStateProvider)) return;

      final scrollViewHeight = scrollController.position.maxScrollExtent;
      final currentScrollPosition = scrollController.position.pixels;
      final screenHeight = scrollController.position.viewportDimension;

      final targetPosition = scrollViewHeight - screenHeight * 1.2;

      if (currentScrollPosition >= targetPosition) {
        ref.read(_loadingStateProvider.notifier).state = true;

        await loadFunction();

        await Future.delayed(const Duration(milliseconds: 1500), () {
          if (!context.mounted) return;

          ref.read(_loadingStateProvider.notifier).state = false;
        });
      }
    }

    scrollController.addListener(() async => await checkScrollPosition());

    return () {
      scrollController.removeListener(checkScrollPosition);
    };
  }, [scrollController]);
}
