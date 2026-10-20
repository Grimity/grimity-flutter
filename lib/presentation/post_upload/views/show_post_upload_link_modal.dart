import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:pervice/pervice.dart';

/// 게시글에 삽입할 링크의 이름과 주소를 입력하는 팝업을 표시합니다.
Future<GdsLink?> showPostUploadLinkModal(BuildContext context) {
  return GdsAdaptiveModal.show<GdsLink>(
    context,
    builder: (context) {
      final name = context.stateOf<String?>(() => null);
      final url = context.stateOf<String>(() => '');
      final canSubmit = url.value.isNotEmpty;

      // 링크 이름이 없으면 URL을 표시 이름으로 사용.
      final GdsLink link = (
        name: name.value ?? url.value,
        url: url.value,
      );

      return GdsAdaptiveModal(
        title: '링크 추가',
        primaryButton: .new(
          label: '완료',
          onTap: () => context.pop(link),
          status: .from(enabled: canSubmit),
        ),
        secondaryButton: .new(
          label: '닫기',
          onTap: context.pop,
        ),
        children: [
          // 링크 주소 입력 필드 표시
          GdsInput.title(
            title: '링크 주소',
            field: GdsTextField.normal(
              size: .md,
              onChanged: url.setter,
              placeholder: 'https://www.grimity.com/board/write',
            ),
          ),

          // 링크 명 입력 필드 표시
          GdsInput.title(
            title: '링크 명',
            field: GdsTextField.normal(
              size: .md,
              onChanged: name.setter,
              placeholder: '링크 주소 대신 보일 내용을 입력해주세요',
            ),
          ),
        ],
      );
    },
  );
}
