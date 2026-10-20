import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/post_upload/pages/post_upload_page.dart';

/// 자유게시판 제목과 글쓰기 버튼을 표시하는 위젯.
class BoardHeader extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .start,
      mainAxisAlignment: .spaceBetween,
      children: [
        // 제목 표시
        GdsText(
          '자유게시판',
          color: .textGrayBold,
          style: context.whenDevice(
            mobile: .title2,
            tablet: .title1,
          ),
        ),

        // 글쓰기 버튼 표시
        GdsButton.text(
          type: .outlined,
          size: .md,
          label: '글쓰기',
          onTap: () {
            // 게시글 업로드 페이지로 이동.
            context.push(const PostUploadPage());
          },
        ),
      ],
    );
  }
}
