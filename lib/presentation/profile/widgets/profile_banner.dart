import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/model/user_profile_response.dart';

/// 사용자 프로필의 배너 이미지를 표시하는 위젯.
class ProfileBanner extends StatelessWidget {
  const new({
    super.key,
    required this.data,
  });

  final UserProfileResponse data;

  /// 프로필 배너 이미지의 가로/세로 비율.
  static const radio = GdsThumbnailRatio.banner;

  @override
  Widget build(BuildContext context) {
    if (data.isMe) {
      if (context.isMobile) {
        return GdsGesture(
          useEffect: false,
          onTap: () {},
          child: AspectRatio(
            aspectRatio: radio.value,
            child: GdsContainer(
              color: .bgOverlayBlack,
            ),
          ),
        );
      }

      // Tablet
      return AspectRatio(
        aspectRatio: radio.value,
        child: GdsContainer(
          alignment: .center,
          color: .bgOverlayBlack,
          child: GdsButton.text(
            type: .solid,
            size: .md,
            leadingIcon: .plus,
            label: '커버 추가하기',
            onTap: () {}, // TODO,
          ),
        ),
      );
    }

    return GdsThumbnail(
      ratio: radio,
      provider: data.backgroundImage?.toImage(),
    );
  }
}
