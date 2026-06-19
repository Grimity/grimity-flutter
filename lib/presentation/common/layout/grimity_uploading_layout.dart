import 'package:flutter/material.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/presentation/common/dialog/cancel_upload_dialog.dart';
import 'package:grimity/presentation/common/widget/grimity_modal_loading.dart';
import 'package:grimity/presentation/common/widget/grimity_pop_scope.dart';

class GrimityUploadingLayout extends StatelessWidget {
  const GrimityUploadingLayout({super.key, required this.child, required this.uploading});

  final Widget child;
  final bool uploading;

  @override
  Widget build(BuildContext context) {
    return GrimityPopScope(
      canPop: false,
      callback: uploading ? () => ToastService.showFailure('업로드가 진행중 입니다.') : () => showCancelUploadDialog(context),
      child: Stack(
        children: [
          child,
          if (uploading)
            GrimityModalLoading(
              title: '이미지를 업로드 중이에요',
              description: '이미지 업로드 도중 화면을 닫거나\n뒤로가면 업로드가 중단될 수 있어요',
            ),
        ],
      ),
    );
  }
}
