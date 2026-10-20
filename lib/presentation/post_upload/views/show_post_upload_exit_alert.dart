import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 글 작성을 취소하고 나갈지 확인하는 팝업을 표시합니다.
Future<void> showPostUploadExitAlert(BuildContext context) async {
  return GdsAlert.show<void>(
    context,
    builder: (context) => GdsAlert(
      title: '업로드를 취소하고 나가시겠어요?',
      description: '작성한 내용들은 모두 초기화돼요',
      primaryButton: .new(
        label: '나가기',
        onTap: () {
          context.pop();
          context.pop();
        },
      ),
      secondaryButton: .new(
        label: '아니요',
        onTap: context.pop,
      ),
    ),
  );
}
