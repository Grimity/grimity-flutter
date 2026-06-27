import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';

class GrimityProfileBackgroundImage extends StatelessWidget {
  const GrimityProfileBackgroundImage({
    super.key,
    this.url,
    this.isMine = false,
  });

  final String? url;
  final bool isMine;

  static const ratio = GdsThumbnailRatio.r4x1;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;

    if (url?.isNotEmpty == true) {
      return GdsThumbnail(
        width: double.infinity,
        ratio: ratio,
        imageUrl: url,
      );
    }

    if (isMine) {
      return AspectRatio(
        aspectRatio: ratio.value,
        child: Container(
          color: colors.bg.overlayBlack.withOpacity(GdsOpacity.opacity40),
          alignment: Alignment.center,
          child: Builder(
            builder: (context) {
              if (context.isMobile) {
                return GdsGesture(
                  onTap: () => ProfileEditRoute().push(context),
                  child: SizedBox.expand(),
                );
              }

              return GdsSolidButton(
                size: context.isMobile ? GdsSolidButtonSize.small : GdsSolidButtonSize.regular,
                text: '커버 추가하기',
                leadingIcon: GdsIcon.plus,
                onPressed: () => ProfileEditRoute().push(context),
              );
            },
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: ratio.value,
      child: Container(
        alignment: Alignment.center,
        color: colors.bg.secondary,
        child: GdsIcon.logo.build(
          height: 25,
          color: colors.border.graySubtle,
        ),
      ),
    );
  }
}
