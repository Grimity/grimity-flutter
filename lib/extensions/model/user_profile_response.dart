import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_user.dart';

/// [UserProfileResponse]에 대한 유틸리티 확장.
extension UserProfileResponseExtension on UserProfileResponse {
  /// 현재 로그인한 사용자의 프로필인지 여부.
  bool get isMe {
    return id == profile.id;
  }
}
