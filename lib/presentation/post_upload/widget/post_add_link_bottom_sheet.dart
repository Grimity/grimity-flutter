import 'package:flutter/material.dart';
import 'package:gds/gds.dart';

typedef PostAddLinkSubmitCallback = void Function(String text, String url);

Future<void> showPostAddLinkPopup(
  BuildContext context, {
  String? initialText,
  String? initialUrl,
  required PostAddLinkSubmitCallback onSubmit,
}) async {
  final textController = TextEditingController(text: initialText ?? '');
  final urlController = TextEditingController(text: initialUrl ?? '');

  void submit() {
    final text = textController.text.trim();
    final url = _normalizeUrl(urlController.text);
    if (url.isEmpty) return;

    onSubmit(text, url);
    Navigator.of(context).pop();
  }

  final child = Column(
    mainAxisSize: MainAxisSize.min,
    spacing: GdsSpacing.spacing12,
    children: [
      GdsInput(
        titleText: '링크 주소',
        placeholder: 'https://www.grimity.com/board/write',
        isRequired: false,
        controller: urlController,
        textInputAction: TextInputAction.next,
      ),
      GdsInput(
        titleText: '링크 명',
        placeholder: '링크 주소 대신 보일 내용을 입력해주세요',
        isRequired: false,
        controller: textController,
        textInputAction: TextInputAction.done,
        onEditingComplete: submit,
      ),
    ],
  );

  try {
    if (context.isMobile) {
      final bottomSheet = GdsBottomSheet(
        title: '링크 추가',
        primaryLabel: '완료',
        onPrimaryTap: submit,
        secondaryLabel: '닫기',
        onSecondaryTap: () => Navigator.of(context).pop(),
        child: child,
      );

      return await bottomSheet.open(context);
    } else {
      final modal = GdsModal(
        title: '링크 추가',
        body: child,
        primaryLabel: '완료',
        onPrimary: submit,
        secondaryLabel: '닫기',
        onSecondary: () => Navigator.of(context).pop(),
      );

      return await modal.open(context);
    }
  } finally {
    textController.dispose();
    urlController.dispose();
  }
}

String _normalizeUrl(String url) {
  final trimmedUrl = url.trim();
  if (trimmedUrl.isEmpty) return trimmedUrl;

  final hasScheme = RegExp(r'^[a-zA-Z][a-zA-Z0-9+\-.]*://').hasMatch(trimmedUrl);
  return hasScheme ? trimmedUrl : 'https://$trimmedUrl';
}
