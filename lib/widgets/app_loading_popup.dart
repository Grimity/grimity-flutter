import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:pervice/pervice.dart';

/// 페이지 이동 또는 업로드 등의 큰 로딩이 발생할 때 노출되는 팝업.
class AppLoadingPopup extends StatelessWidget {
  const new({
    super.key,
    required this.title,
    required this.description,
    required this.onAsync,
  });

  final String title;
  final String description;
  final AsyncCallback onAsync;

  @override
  Widget build(BuildContext context) {
    // 최초 빌드 시 비동기 작업을 실행하고, 완료되면 현재 팝업 닫기.
    context.onInitState(() async {
      try {
        await onAsync();
      } finally {
        if (context.mounted) context.pop();
      }
    });

    return GdsContainer(
      minWidth: 220,
      maxWidth: 320,
      color: .surfaceBase,
      radius: .xl,
      shadow: .level2,
      padding: context.whenDevice(
        mobile: .all(32),
        tablet: .all(40),
      ),
      child: Column(
        mainAxisSize: .min,
        children: [
          const GdsRefreshLoading(size: 40),
          context.whenDevice(
            mobile: const Gap(20),
            tablet: const Gap(32),
          ),

          // 제목 표시
          GdsText(
            title,
            color: .textGrayBold,
            style: .title2,
            textAlign: .center,
          ),
          context.whenDevice(
            mobile: const Gap(4),
            tablet: const Gap(10),
          ),

          // 설명 표시
          GdsText(
            description,
            color: .textGrayBold,
            style: .body1R,
            textAlign: .center,
          ),
        ],
      ),
    );
  }

  /// 로딩 팝업을 오버레이에 표시합니다.
  Future<T?> open<T>(BuildContext context) {
    final route = GdsPopupRoute<T>(
      barrierDismissible: false,
      child: this,
    );

    return Navigator.push(context, route);
  }
}
