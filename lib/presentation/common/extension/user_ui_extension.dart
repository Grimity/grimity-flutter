import 'package:gds/gds.dart';
import 'package:grimity/domain/entity/user.dart';

extension UserUiExtension on User {
  GdsPersonAvatar get personAvatar => GdsPersonAvatar(imageUrl: image);
}
