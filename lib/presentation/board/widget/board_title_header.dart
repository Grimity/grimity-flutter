import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';

class BoardTitleHeader extends StatelessWidget {
  const BoardTitleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '자유게시판',
          style: context.isMobile
              ? GdsTypography.title2.copyWith(color: colors.text.grayBold)
              : GdsTypography.title1.copyWith(color: colors.text.grayBold),
        ),
        GdsOutlinedButton(
          text: '글쓰기',
          onPressed: () {
            PostUploadRoute().push(context);
          },
        ),
      ],
    );
  }
}
